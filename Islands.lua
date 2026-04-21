------------------------------------------------------------------------
-- Islands.lua — Banco de ilhas do Royal Hub
-- Carregado dinamicamente pelo Source.lua via loadstring
-- Para adicionar um novo jogo: copie um bloco e edite PlaceIds, name,
-- detectSea e as coordenadas pos = Vector3.new(X, Y, Z)
--
-- COMO PEGAR COORDENADAS:
--   print(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position)
------------------------------------------------------------------------

_G.RH = _G.RH or {}
local G = _G.RH

-- =====================================================================
--  Cada entrada mapeia UM PlaceId para um bloco de dados.
--  King Legacy tem DOIS PlaceIds (um por sea), então ambos apontam
--  para o mesmo bloco — mas detectSea usa posição pra distinguir
--  sub-regiões dentro de cada mapa.
-- =====================================================================

local IslandDB = {}

-- ─────────────────────────────────────────────────────────────────────
--  KING LEGACY — Sea 1  (PlaceId 4520749081)
-- ─────────────────────────────────────────────────────────────────────
IslandDB[4520749081] = {
    name      = "King Legacy",
    placeIds  = { 4520749081 },   -- IDs que pertencem a este bloco
    -- Sea 1 é mapa único, não tem sub-seas por posição X
    detectSea = function() return 1 end,
    seas = {
        [1] = {
            { Title = "Starter Island",   pos = Vector3.new(100,  10,  100) },
            { Title = "Jungle Island",    pos = Vector3.new(600,  10,  300) },
            { Title = "Desert Island",    pos = Vector3.new(1300, 10, -200) },
            { Title = "Snow Island",      pos = Vector3.new(-700, 10,  700) },
            { Title = "Sky Island",       pos = Vector3.new(200,  620, 200) },
            { Title = "Marine Base",      pos = Vector3.new(-1500,10, -500) },
            { Title = "Colosseum",        pos = Vector3.new(-300, 10, -900) },
        },
    },
}

-- ─────────────────────────────────────────────────────────────────────
--  KING LEGACY — Sea 2  (PlaceId 6381829480)
--  Este mapa tem os seas 2 e 3 separados por coordenada X
-- ─────────────────────────────────────────────────────────────────────
IslandDB[6381829480] = {
    name     = "King Legacy",
    placeIds = { 6381829480 },
    detectSea = function()
        local ok, val = pcall(function()
            -- tenta ler o valor direto do ReplicatedStorage (mais confiável)
            local rs    = game:GetService("ReplicatedStorage")
            local paths = {
                {"GameData", "Sea"},
                {"Data",     "Sea"},
                {"SeaData",  "Value"},
            }
            for _, p in ipairs(paths) do
                local cur = rs
                for _, part in ipairs(p) do
                    cur = cur:FindFirstChild(part)
                    if not cur then break end
                end
                if cur and cur.Value then return cur.Value end
            end
            -- fallback: detecta pelo eixo X do personagem
            local root = game:GetService("Players").LocalPlayer.Character
            root = root and root:FindFirstChild("HumanoidRootPart")
            if root then
                local x = root.Position.X
                if     x > 6000 then return 3
                elseif x > 2500 then return 2 end
            end
            return 2   -- padrão deste PlaceId é Sea 2
        end)
        return (ok and type(val) == "number") and val or 2
    end,
    seas = {
        [2] = {
            { Title = "Sea 2 — Spawn",      pos = Vector3.new(3000, 10,  100) },
            { Title = "Sea 2 — Dark Zone",  pos = Vector3.new(3600, 10,  600) },
            { Title = "Sea 2 — Fire Isle",  pos = Vector3.new(4100, 10, -300) },
            { Title = "Sea 2 — Thunder",    pos = Vector3.new(4700, 10,  400) },
            { Title = "Sea 2 — Ice Cave",   pos = Vector3.new(5200, 10, -600) },
        },
        [3] = {
            { Title = "Sea 3 — Spawn",      pos = Vector3.new(7200, 10,  100) },
            { Title = "Sea 3 — Void Isle",  pos = Vector3.new(7900, 10, -400) },
            { Title = "Sea 3 — Thunder",    pos = Vector3.new(8500, 10,  500) },
            { Title = "Sea 3 — Final Boss", pos = Vector3.new(9200, 10,    0) },
        },
    },
}

-- ─────────────────────────────────────────────────────────────────────
--  BLOX FRUITS  (PlaceId 2753915549)
-- ─────────────────────────────────────────────────────────────────────
IslandDB[2753915549] = {
    name     = "Blox Fruits",
    placeIds = { 2753915549 },
    detectSea = function()
        local ok, val = pcall(function()
            local root = game:GetService("Players").LocalPlayer.Character
            root = root and root:FindFirstChild("HumanoidRootPart")
            if not root then return 1 end
            local x = root.Position.X
            if     x < -5000            then return 3
            elseif x > 2000 or x < -1000 then return 2 end
            return 1
        end)
        return (ok and type(val) == "number") and val or 1
    end,
    seas = {
        [1] = {
            { Title = "Starter Island",  pos = Vector3.new(-1353,  3,   344) },
            { Title = "Middle Town",     pos = Vector3.new( -493,  3,  1988) },
            { Title = "Jungle",          pos = Vector3.new( 1773,  3,   672) },
            { Title = "Pirate Village",  pos = Vector3.new(-1430,  3, -1280) },
            { Title = "Desert",          pos = Vector3.new(  930,  3, -2793) },
            { Title = "Snow Mountain",   pos = Vector3.new(-1107,  3, -3228) },
            { Title = "Marine Fortress", pos = Vector3.new(-2750,  3, -1300) },
            { Title = "Skylands",        pos = Vector3.new(-4655, 879,  -752) },
        },
        [2] = {
            { Title = "Kingdom of Rose", pos = Vector3.new( -223,  3, -3012) },
            { Title = "Green Zone",      pos = Vector3.new( 4423,  3, -2363) },
            { Title = "Graveyard",       pos = Vector3.new( 4380,  3,  -789) },
            { Title = "Ice Castle",      pos = Vector3.new( 6195,  3, -3370) },
            { Title = "Colosseum",       pos = Vector3.new(  924,  3, -5004) },
            { Title = "Floating Turtle", pos = Vector3.new(-13616,845, -4481) },
        },
        [3] = {
            { Title = "Port Town",       pos = Vector3.new( -7900, 10, -1100) },
            { Title = "Hydra Island",    pos = Vector3.new( -9200, 10,  -900) },
            { Title = "Great Tree",      pos = Vector3.new(-10500, 10, -1300) },
            { Title = "Haunted Castle",  pos = Vector3.new(-11700, 10,  -500) },
            { Title = "Sea of Treats",   pos = Vector3.new(-13000, 10, -1500) },
        },
    },
}

 IslandDB[15759515082] = {
     name     = "King Legacy",
     placeIds = { 15759515082 },
     detectSea = function() return 1 end,   -- sem seas: sempre retorna 1
     seas = {
         [1] = {
             { Title = "The Unearthly {4000}", pos = Vector3.new(2174.659912109375, 35.610984802246094, 1308.9000244130625) },
             { Title = "The Shallow {4300}", pos = Vector3.new(3761.74072265625, 45.21211624145508, 8742.19140625) },
             { Title = "Drakenhold Fortress {4400}", pos = Vector3.new(-933.8525390625, 17.779321670532227, -7669.59716796875) },
             { Title = "Forgotten Coliseum {4550}", pos = Vector3.new(-4465.654296875, 22.248180389404297, 568.4514770507812) },
             { Title  = "Land of Detention {4800}", pos = Vector3.new(9986.583984375, 35.843955993652344, 1186.517822265625) },
             { Title = "Primeval Isle {5000}", pos = Vector3.new(-69965.10400390625, 67.58403778076172, 10911.1650390625) },
             { Title = "Luma Grove", pos = Vector3.new(-610.7909545898438, 187.6682891845703, 4013.5866699921875) },
             { Title = "Crownfall Isle", pos = Vector3.new(6539.3310546875, 31.258283615112305, -5521.24365234375) },

         },
     },
 }

-- ─────────────────────────────────────────────────────────────────────

-- expõe o DB globalmente para o Source.lua
G.IslandDB = IslandDB

print("[RoyalHub] Islands.lua carregado — " .. (function()
    local n = 0; for _ in pairs(IslandDB) do n = n + 1 end; return n
end)() .. " entradas no banco de ilhas.")
