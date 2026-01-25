import sys
from datetime import datetime

def get_input(prompt, default=""):
    value = input(prompt).strip()
    return value if value else default

def main():
    print("--- Accounty Entry Helper ---")
    
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
    
    print("\n--- Copy the line below ---")
    print(csv_string)
    print("---------------------------\n")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nExiting...")
        sys.exit()
