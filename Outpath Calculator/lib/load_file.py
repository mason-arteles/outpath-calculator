import json

save_file_path = "%%appdata%%/../LocalLow/DAVII PROJECTS/Outpath First Journey/SaveFile1.es3"

save_data = None

with open(save_file_path) as save_file:
    save_data = json.load(save_file)

building_counts = {}
building_map = {3: "collection_net"}

for (field, value) in save_data:
    match field.split("_"):
        case ["IPG",_,"Index"]:
            building = building_map[value["value"]]
            building_counts[building] = building_counts.setdefault(building, 0) + 1
            break