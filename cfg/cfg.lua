local cfg = {}

cfg.dealerships = {
  ["PDM"] = {
    blips = true,
    blip = {id = 225, colour = 3, scale = 0.85, coords = {-34.2373, -1097.0710, 27.2744}},
    vehicles = {
      {name = "adder", label = "Adder", class= 'super', price = 90000},
      {name = "zentorno", label = "Zentorno",class='super', price = 90000},
      {name = 'dominator9', label = "Dominator GT", class='muscle',price = 45000},
      {name = 'akuma', label = "Akuma", class='motorcycle',price = 12000},
      {name = 'aleutian', label = "	Aleutian", class='suv',price = 32000},
      {name = 'alpha', label = "	Alpha", class='sedan',price = 18000},
      {name = 'asea', label = "Asea", class='sedan',price = 8000},
      {name = 'asterope', label = "Asterope", class='sedan',price = 10000},
      {name = 'asterope2', label = "Asterope GZ", class='sedan',price = 13000},
      {name = 'astron', label = "Astron", class='suv',price = 56000},
      {name = 'autarch', label = "Autarch", class='super',price = 161000},
    },
    positions = {
      [1] = {
        coords = {-54.5552, -1096.9774, 26.2},
        heading = 303.2848,
        model = "adder",
        interaction = {
          coords = {-51.55, -1095.08, 27.27}
        }
      },
      [2] = {
        coords = {-49.8461, -1083.7850, 26.2},
        heading = 153.0326,
        model = "zentorno",
        interaction = {
          coords = {-51.08, -1086.9, 27.27}
        }
      },
      [3] = {
        coords = {-47.7225, -1091.6449, 26.4},
        heading = 192.7324,
        model = "dominator9",
        interaction = {
          coords = {-46.7817, -1095.7964, 27.2744}
        }
      }
    },
    vehSpawn = {-31.514749526978, -1090.6414794922, 26.422248840332},
    heading = 343.273
  },
  ["Mission Row Police Dept."] = {
    blips = true,
    blip = {id = 487, colour = 3, scale = 1.0, coords = {431.3609, -986.7430, 25.7}},
    vehicles = {
      {name = "police", label = "Police 1", price = 1000},
      {name = "police2", label = "Police 2", price = 2000}
    },
    positions = {
      [1] = {
        coords = {425.8879, -981.5768, 25.3054},
        heading = 267.9771,
        model = "police",
        interaction = {
          coords = {425.88, -981.64, 25.7}
        }
      }
    },
    vehSpawn = {434.8955, -975.7712, 25.7000},
    heading = 238.8992
  }
}
return cfg
