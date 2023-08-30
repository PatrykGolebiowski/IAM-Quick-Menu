import os
import csv

# Function to load the licensing data from the CSV file
def load_licensing_data():
    script_directory = os.path.dirname(os.path.abspath(__file__))
    licensing_file_path = os.path.join(script_directory, "..", "assets", "licensing.csv")

    # Create an empty dictionary to store the licensing data
    licensing_data = {}

    # Open the licensing.csv file using the specified encoding
    with open(licensing_file_path, newline="", encoding="cp1252") as csvfile:
        # Create a CSV reader to read the file
        reader = csv.DictReader(csvfile)

        # Iterate over each row in the CSV file
        for row in reader:
            sku_id = row["GUID"]
            service_plan_id = row['Service_Plan_Id']

            product_display_name = row["Product_Display_Name"]
            service_plan_display_name = row['Service_Plans_Included_Friendly_Names']

            # Store the mapping in the licensing data dictionary
            licensing_data[sku_id] = product_display_name
            licensing_data[service_plan_id] = service_plan_display_name

    # Return the loaded licensing data
    return licensing_data
