<div align="center">
  <h1>Accounty</h1>
  <h4>A macOS native expense tracker to manage and analyze one's assets and expenses.</h4>
  <p>
    <img src="showcase/accounty_icon.png" alt="Main Menu Image" width="20%">
  </p>
</div>

> [!NOTE]
> The application still needs a lot more work.

## Showcase

After logging in, the user is welcomed with the following main menu:

<p align="center">
  <img src="showcase/main_menu.png" alt="Main Menu Image" width="40%">
</p>

And can take a peek, in the Reports menu, at the overall financial situation:

<p align="center">
  <img src="showcase/reports.png" alt="Reports Image" width="80%">
</p>

## Functionalities

Accounty allows the user to do the following:

- Inserting statements in the **New Entry** view, whether they are of the income or the expense type, and categorizing them;
- Accessing the **Reports** view to see an overview of the month's cashflow;
- Viewing the **History** of entries;
- Setting positions to have an overview of the NAV in **Positions**;
- **Import Data** from a csv file;
- Access the **Settings**, which is currently a placeholder.

> [!TIP]
> To import data into the application, entries must be collected in a csv file in the following format:
```csv
timestamp,type,category,desc,amount,notes
2026-01-01,Expense,Entertainment,New Switch Game,40.99,Super Mario Odyssey
2026-01-10,Income,Salary,Main Job,1000,
```
> This can be achieved by launching the python helper script with this command:
```python
# Windows
python format_new_entry.py

# MacOS
python3 format_new_entry.py
```
