import json
import os

save_file_path = os.environ['USERPROFILE']+"/AppData/LocalLow/DAVII PROJECTS/Outpath/SaveFile1.es3"
#"C:\Users\hardy\AppData\LocalLow\DAVII PROJECTS\Outpath"
save_data = None

with open(save_file_path) as save_file:
    save_data = json.load(save_file)

"hi"

ids = {}

for (field, value) in save_data.items():
    "hi"
    match field.split("_"):
        case ["IPG",id_value,"CollNet",*_]:
            structure_id = save_data["IPG_"+id_value+"_Index"]['value']
            amount = ids.setdefault(structure_id, 0)
            ids[structure_id] = amount + 1

print(ids)

# Collection net = 3