require("dotenv").config();
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const path = require("path");
const vision = require("@google-cloud/vision");
const { Configuration, OpenAIApi } = require("openai");

// Initialize Firebase Admin
admin.initializeApp();

// Initialize Google Vision API with the key file
const visionClient = new vision.ImageAnnotatorClient({
  keyFilename: path.join(__dirname, "vision-key.json"),
});

// Initialize OpenAI
const openai = new OpenAIApi(
  new Configuration({
    apiKey: process.env.OPENAI_API_KEY,
  })
);

// Cloud Function to generate recipes
exports.generateRecipes = functions.https.onCall(async (data, context) => {
  try {
    const base64Image = data.imageBase64;

    if (!base64Image) {
      throw new functions.https.HttpsError("invalid-argument", "No image provided.");
    }

    // Step 1: Extract text from the image using Vision API
    const [result] = await visionClient.textDetection({
      image: { content: base64Image },
      imageContext: { languageHints: ["bg"] }, // Bulgarian language hint
    });

    const extractedText = result.textAnnotations[0]?.description || "";

    if (!extractedText.trim()) {
      throw new functions.https.HttpsError("not-found", "No text detected in the image.");
    }

    // Step 2: Build prompt for OpenAI
    const prompt = `
Текст от изображението (на български): 
${extractedText}

Създай 10-15 креативни рецепти, базирани на горния списък със съставки на български език.
`;

    // Step 3: Get recipes from OpenAI
    const completion = await openai.createChatCompletion({
      model: "gpt-4",
      messages: [
        {
          role: "system",
          content: "Ти си креативен готвач, който пише рецепти на български език.",
        },
        {
          role: "user",
          content: prompt,
        },
      ],
      temperature: 0.8,
    });

    const recipes = completion.data.choices[0].message.content;

    return { recipes };
  } catch (error) {
    console.error("generateRecipes error:", error);
    throw new functions.https.HttpsError("internal", "Failed to generate recipes.");
  }
});
