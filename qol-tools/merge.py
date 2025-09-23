import os 
import PyPDF2
from PyPDF2 import PdfReader , PdfWriter, PdfMerger

# Add absolute paths to input pdfs
pdfFiles = ['C:\\Users\\Mike\\Downloads\\drive-download-20250923T085230Z-1-001\\a1.pdf', 'C:\\Users\\Mike\\Downloads\\drive-download-20250923T085230Z-1-001\\a2.pdf']

pdfWriter = PyPDF2.PdfWriter()

for filename in pdfFiles:
    pdfFileObj = open(filename, 'rb')
    pdfReader = PyPDF2.PdfReader(pdfFileObj)
    for pageNum in range(0, len(pdfReader.pages)):
        pageObj = pdfReader.pages[pageNum]
        pdfWriter.add_page(pageObj)

# Outputs relative to the script location
pdfOutput = open('Merged.pdf', 'wb') 
pdfWriter.write(pdfOutput)
pdfOutput.close()