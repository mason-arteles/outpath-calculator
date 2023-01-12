# Outpath Build Cost Calculator
# 

# i might try to load in some stuff from save file directly

properties = {
    "thrift_level": 0
}

structure_costs = {
    "collection_net": {"wood": 6, "thread": 2},
    "inscription_table": {"wood": 25, "brick": 2},
    "workbench": {"wood": 2, "flower": 3},
    "furnace": {"stone": 10},
    "skills_shop": {"glass": 2, "brick": 2},
    "spinning_wheel": {"fibers": 10, "wood": 15, "brick": 2},
    "anvil": {"copper_ingot": 3, "brick": 2},
    "cauldron": {"flower": 30, "iron_ingot": 3, "brick": 2},
    "imbuing_table": {"magic_branch": 5, "black_bone": 2, "brick": 6},
    "cooking_pot": {"wood": 30, "coal": 10, "brick": 5},
    "spreader": {"wood": 40, "fibers": 40, "berry": 15, "brick": 5},
    "recycler": {"fibers": 30, "flower": 15, "copper_ingot": 2, "brick": 4},
    "soil_miner": {"iron_ingot": 6, "sand": 15, "brick": 5},
    "mill": {"wood": 20, "thread": 10, "brick": 5},
    "trading_post": {"wood": 20, "leather": 3, "brick": 5},
    "jump_pad": {"leather": 2, "wood": 30},
    "breaker": {"glass": 4, "copper_ingot": 4, "brick": 4},
    "mining_post": {"glass": 5, "gold_ingot": 2, "brick": 10},
    "collector": {"stone": 30, "iron_ingot": 6, "brick": 8}
}

plurals: {
    "flower": "flowers",
    "copper_ingot": "copper ingots",
    "berry": "berries",
    "iron_ingot": "iron ingots",
    "gold_ingot": "gold ingots",
    "brick": "bricks",
    "black_bone": "black bones"
}

def get_command_help(command):
    match command:
        case [('get', 'thrift'), *_]:
            return """
                Gets your current Thrift level.
                Usage:

                > thrift
                > get thrift
                # Gets the current thrift level.
                """
        case [('set', 'thrift'), *_]:
            return """
                Sets your current thrift level.
                Usage:

                > set thrift 3
                > thrift 3
                # Sets the current thrift level to 3
                """
        case ['thrift', *_]:
            return """
                Get or set your current thrift level.
                Usage:

                > thrift
                # Gets the current thrift level

                > thrift 3
                # Sets current thrift level to 3
                """
        case [(("cost" | "price") | (("cost" | "price"), "of")), *_]:
            return """
                Calculates the total cost of structures.
                Usage:

                > cost of 3 collection net
                # Gets the cost of 3 collection nets.
                
                > price 2 furnace
                # Gets the cost of 2 furnaces.

                > price of 5 spinning wheels, i have 4
                # Gets the cost of 5 spinning wheels, provided you have 4 already built.
                # You can use "has" "have" or "with" in place of "i have", or it can be omitted.


                """

def get_structure_name(structure_name):
    if structure_name.endswith(" x"):
        structure_name = structure_name[:-2]
    if structure_name.endswith("s")
        structure_name = structure_name[:-1]
    
    if structure_name == "work_bench":
        structure_name = 'workbench'
    
    if not structure_name in structure_costs.keys():
        return None
    return structure_name

def save_config():
    "do smth"

def get_required_resources(structure_name, i_have, count):
    structure_data = structure_costs[structure_name]
    resource_object = {}
        for [resource, amount] in structure_data: # assuming that count > 0
            if not resource in resource_object.keys():
                resource_object[resource] = 0
            for step in range(i_have, count + i_have):
                resource_object[resource] += get_required_amount(amount, step)
    return resource_object
    
def get_required_amount(amount, placed):
    amount = round(amount + (amount * placed * placed / 12))
    amount = round(amount * (1 - 0.15 * properties.thrift_level))

    return amount if amount > 1 else 1

# MAIN

input_string = ""

while not input_string == "stop":
    input_string = input("> ").strip().lower()
    match input_string.split(/[ :=_,]+/):
        case [('help' | 'syntax' | ('syntax','of')), *command]:
            get_command_help(command):
        case (['get', 'thrift'] | ('thrift')):
            print("Your thrift level is %d", properties.thrift_Level)
        case [(('thrift') | ('set', 'thrift')), level]:
            if not level == properties.thrift_level:
                properties.thrift_level = level
        case [("cost" | "price") | (("cost" | "price"), "of")]:
        case [(("cost" | "price") | (("cost" | "price"), "of")), *structure_name]
        case [((('cost' | 'price'), 'of') | ('cost' | 'price')), count, *stucture_name] \
                if count.isnumeric():
        case [((('cost' | 'price'), 'of') | ('cost' | 'price')), *stucture_name, count] \
                if count.isnumeric():
        case [((('cost' | 'price'), 'of') | ('cost' | 'price')), *stucture_name, count, ["with" | "has" | ("i", "have") | "have"], i_have] \
                if count.isnumeric() and i_have.isnumeric():
        case [((('cost' | 'price'), 'of') | ('cost' | 'price')), *stucture_name, count, i_have] \
                if count.isnumeric() and i_have.isnumeric():
        case [((('cost' | 'price'), 'of') | ('cost' | 'price')), *stucture_name, count, i_have] \
                if count.isnumeric() and i_have.isnumeric():
            
            if structure_name and len(strcuture_array) > 0:
                structure_name = structure_name.join("_"):
            else:
                structure_name = input("What structure are you building? > ")
            
            while not (count.isnumeric() and int(count) >= 0):
                count = input("How many do you want to build? > ")
            count = int(count)

            while not (i_have.isnumeric() and int(i_have) >= 0):
                i_have = input("How many do you have placed already? > ")
            i_have = int(i_have)

            structure_name = get_structure_name(structure_name)
            if structure_name is None:
                print('Could not identify a structure with identifier %s', structure_name)
                break
            
            required_resources = get_required_resources(structure_name, i_have, count)
            print("You will need:")
            for [resource, amount] of required_resources:
                print("> %d %s", amount, plurals[resource] if amount > 1 and plurals.keys().contains(resource) else resource.replace("_", " "))
            print()
        case ['stop']:
            "do nothing"
        case _:
            print("Could not understand the provided input. Please use the help command if you aren't sure.")