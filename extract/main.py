import pytesseract
from PIL import Image
import cv2
import numpy as np
import os

def extract_text_from_image(image_path, preprocess=False):
    """
    Extract text from an image using OCR.
    
    Parameters:
    - image_path: Path to the image file
    - preprocess: Whether to apply preprocessing for better OCR results
    
    Returns:
    - Extracted text as a string
    """
    try:
        # Load the image
        image = cv2.imread(image_path)
        
        # Convert to grayscale
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        
        if preprocess:
            # Apply thresholding to get a binary image
            gray = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]
            
            # Alternatively, you can use adaptive thresholding
            # gray = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, 
            #                             cv2.THRESH_BINARY, 11, 2)
            
            # Apply some morphological operations to remove noise
            kernel = np.ones((1, 1), np.uint8)
            gray = cv2.dilate(gray, kernel, iterations=1)
            gray = cv2.erode(gray, kernel, iterations=1)
        
        # Save the processed image temporarily (for debugging)
        temp_filename = "temp_processed.png"
        cv2.imwrite(temp_filename, gray)
        
        # Use pytesseract to extract text
        text = pytesseract.image_to_string(Image.open(temp_filename))
        
        # Clean up temporary file
        os.remove(temp_filename)
        
        return text.strip()
    
    except Exception as e:
        print(f"Error processing image: {e}")
        return ""

if __name__ == "__main__":
    # Set the path to Tesseract executable (if not in PATH)
    # pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'
    
    # Get image path from user
    image_path = input("Enter the path to the image file: ").strip('"')
    
    if not os.path.isfile(image_path):
        print("Error: File not found.")
    else:
        # Ask if preprocessing should be applied
        preprocess = input("Apply preprocessing for better results? (y/n): ").lower() == 'y'
        
        # Extract text
        extracted_text = extract_text_from_image(image_path, preprocess)
        
        # Print results
        print("\nExtracted Text:")
        print("=" * 50)
        print(extracted_text)
        print("=" * 50)
        
        # Option to save to file
        save_to_file = input("\nSave extracted text to a file? (y/n): ").lower() == 'y'
        if save_to_file:
            output_path = os.path.splitext(image_path)[0] + "_extracted.txt"
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(extracted_text)
            print(f"Text saved to: {output_path}")