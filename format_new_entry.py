import sys
from datetime import datetime

def get_input(prompt, default=""):
    value = input(prompt).strip()
    return value if value else default

def build_csv_string():
    # 1. Date (Defaults to today in yyyy-mm-dd format)
    today = datetime.now().strftime("%Y-%m-%d")
    date = get_input(f"Date (yyyy-mm-dd) [{today} will be considered if input is invalid]: ", today)
    
    # 2. Type (Income/Expense)
    print("Type: [1] Expense [2] Income")
    type_choice = get_input("Choice [1]: ", "1")
    entry_type = "Income" if type_choice == "2" else "Expense"
    
    # 3. Category
    category = get_input("Category (e.g., Food, Entertainment): ")
    
    # 4. Description
    desc = get_input("Description: ")
    
    # 5. Amount
    amount = get_input("Amount: ")
    try:
        float(amount)
    except ValueError:
        print("Error: Amount must be a number.")
        return

    # 6. Notes
    notes = get_input("Notes (Optional): ")

    # Format into CSV string: timestamp,type,category,desc,amount,notes
    csv_string = f"{date},{entry_type},{category},{desc},{amount},{notes}"

    return csv_string


def main():
    print("--- Accounty Entry Formatter ---")
    print("--- An intuitive util to format ready-to-import csv strings ---")

    csv_strings = []
    while True:
        # Assuming at least one string needs to be added, I'll build it straight away.
        new_csv_string = build_csv_string()
        if not new_csv_string:
            print("The string had some errors. Please try again.\n")
            continue

        print("\n--- String that has just been created and formatted ---")
        print(new_csv_string)
        print("---------------------------\n")

        # Update the DS.
        csv_strings.append(new_csv_string)

        # Exit if user asks to do so.
        another_one = get_input("Do you want to format another one? (y/n) ")
        if another_one.lower() == 'n':
            if len(csv_strings) > 1:
                print("\n--- Copy and paste these strings to the csv file ---")
            else:
                print("\n--- Copy and paste the string to the csv file ---")

            for csv_str in csv_strings:
                print(csv_str)
            
            print("---------------------------\n")
            break
        

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nExiting...")
        sys.exit()
