# Data Cleaning & Structural Validation | VirtualWorks Task 1

## Executive Summary
This repository contains the completed deliverable for **Task 1: Data Cleaning & Structural Validation** as part of the VirtualWorks Data Analytics Internship. 

The primary objective of this project was to take an unstructured, messy Excel dataset containing duplicate records, invalid calculations, irregular capitalization, inconsistent text delimiters, and missing values, and transform it into a standardized, reliable, and production-ready data asset suitable for downstream analytics and BI dashboarding.

---

## Project Structure
```text
VirtualWorksTask1/
├── data/
│   ├── Raw.xlsx                  # Original unmodified raw dataset
│   └── Data Cleaning.xlsx        # Final cleaned Excel workbook
├── screenshots/                  # Image proofs of cleaning steps
└── Readme.md                     # Project documentation & pipeline breakdown
```

---

## Visual Transformation Overview

| Raw Dataset (Before Cleaning) | Cleaned Dataset (After Cleaning) |
| :---: | :---: |
| ![Raw Dataset](screenshots/00_dataset_before.png) | ![Cleaned Dataset](screenshots/00_dataset_after.png) |

---

## Step-by-Step Data Cleaning Pipeline

### Step 1: Gridline Clean-up & Dimension Autofitting
- **Problem:** Text strings overflowed column boundaries and numerical metrics displayed as `######` formatting errors.
- **Solution:** Selected the entire sheet (`Ctrl + A`) and executed Excel's auto-fit commands for both column widths and row heights.
- **Shortcuts Used:** `Alt + H + O + I` (Column Width) | `Alt + H + O + A` (Row Height)

| Before Autofit | After Autofit |
| :---: | :---: |
| ![Before Autofit](screenshots/01_autofit_before.png) | ![After Autofit](screenshots/01_autofit_after.png) |

---

### Step 2: Removing Stock Tickers & Lowercasing Client Names
- **Problem:** Client names contained extra parenthetical exchange tickers (e.g., `(XNAS:AMZN)`) and inconsistent uppercase formatting.
- **Solution:** 
  1. Used Find & Replace (`Ctrl + H`) with the wildcard search string `(*)` to remove all parenthetical ticker data.
  2. Applied `=LOWER()` in a helper column to standardize all client strings to lowercase.
  3. Replaced formulas with static values via Paste Special (`Alt + H + V + V`).

| Step 2 Summary | Image Proof |
| :--- | :---: |
| **Wildcard Find & Replace Setup (Step 1)** | ![Replacing Ticker Pattern 1](screenshots/02_client_find_replace1.png) |
| **Wildcard Find & Replace Setup (Step 2)** | ![Replacing Ticker Pattern 2](screenshots/02_client_find_replace2.png) |
| **Lower Function (`=LOWER(C3)`)** | ![Lower Function Setup](screenshots/02_client_lowercase.png) |
| **Final Lowercased Client Column** | ![Clean Client Column](screenshots/02_client_cleaned.png) |

---

### Step 3: Text Normalization (TRIM & PROPER) on Contact Names
- **Problem:** Contact names suffered from trailing spaces, irregular gaps, and mixed casing (e.g., `Bill SmITH`, `Harley   Fritz`).
- **Solution:** Applied a nested text transformation function to strip extra spaces and standardize to Proper Case.
- **Formula:** `=TRIM(PROPER(D3))`

| Before TRIM & PROPER | After TRIM & PROPER |
| :---: | :---: |
| ![Before Trim Proper](screenshots/03_contact_before.png) | ![After Trim Proper](screenshots/03_contact_cleaned.png) |
| *Formula applied: `=TRIM(PROPER(D3))`* | ![Formula Implementation](screenshots/03_contact_formula.png) |

---

### Step 4: Text-to-Columns Delimitation (Department & Region)
- **Problem:** `Department` and `Region` were concatenated into a single compound field separated by an underscore (e.g., `Cloud Tech_Texas`).
- **Solution:** Used Excel's **Convert Text to Columns Wizard** with `Other: _` set as the custom delimiter to separate the data into two distinct fields.

| Before Split | Text to Columns Wizard Setup | Processed Department & Region Columns |
| :---: | :---: | :---: |
| ![Before Split](screenshots/04_text_to_columns_wizard1.png) | ![Text to Columns Wizard](screenshots/04_text_to_columns_wizard2.png) | ![Split Department and Region](screenshots/04_text_to_columns_result.png) |

---

### Step 5: Handling Missing/Null Values
- **Problem:** The dataset contained blank cells across financial and payment columns, creating data gaps.
- **Solution:** Selected missing cells using `Go To Special > Blanks` (`Ctrl + G`), entered `"N/A"`, and batch-populated all empty fields simultaneously with `Ctrl + Enter`.

| Before Null Population | After Null Population |
| :---: | :---: |
| ![Before Handling Nulls](screenshots/05_null_handling_before.png) | ![After Handling Nulls](screenshots/05_null_handling_after.png) |

---

### Step 6: Defensive Error Handling (Profit Margin Calculation)
- **Problem:** Missing revenue data resulted in standard division formulas returning `#DIV/0!` errors.
- **Solution:** Wrapped the division logic inside an `IFERROR` function to catch division errors and output a clean `"N/A"` string.
- **Formula:** `=IFERROR((I3/H3), "N/A")`

| Profit Margin Column with Errors | IFERROR Formula Implementation Proof |
| :---: | :---: |
| ![Profit Margin Errors](screenshots/06_error_handling_iferror1.png) | ![IFERROR Formula Proof](screenshots/06_error_handling_iferror2.png) |

---

### Step 7: Deduplication & Final Validation
- **Problem:** Raw dataset contained redundant duplicate records.
- **Solution:** Executed **Remove Duplicates** across all columns to purge duplicate records while preserving data integrity.
- **Result:** **3 duplicate values** were found and removed; **28 unique rows** remained.

| Remove Duplicates Window | Deduplication Result Confirmation |
| :---: | :---: |
| ![Remove Duplicates Menu](screenshots/07_deduplication_dialog.png) | ![Deduplication Confirmation](screenshots/07_deduplication_result.png) |

---

## Technical Skills & Excel Functions Demonstrated
- **Text Processing:** `=LOWER()`, `=TRIM()`, `=PROPER()`, Text-to-Columns (Underscore Delimiter), Wildcard Find & Replace (`(*)`).
- **Logical & Error Handling:** `=IFERROR()`, `Go To Special > Blanks`.
- **Data Hygiene & Quality Control:** Deduplication, Paste as Values (`Alt + H + V + V`), Autofitting Dimensions (`Alt + H + O + I` / `Alt + H + O + A`).
