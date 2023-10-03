-- Classe Blip
BlipClass = {}
BlipClass.__index = BlipClass

-- Constructeur
function BlipClass:new(coords, sprite, scale, color, opacity, name, shortRange)
    local self = setmetatable({}, BlipClass)
    self.Coords = coords or Config.DefaultBlipSettings.Coords
    self.Sprite = sprite or Config.DefaultBlipSettings.Sprite
    self.Scale = scale or Config.DefaultBlipSettings.Scale
    self.Color = color or Config.DefaultBlipSettings.Color
    self.Opacity = opacity or Config.DefaultBlipSettings.Opacity
    self.Name = name or Config.DefaultBlipSettings.Name
    self.ShortRange = shortRange or Config.DefaultBlipSettings.ShortRange
    self.Handle = nil6
    return self
end

-- Méthode pour créer le blip
function BlipClass:create()
    local blip = AddBlipForCoord(self.Coords)
    SetBlipSprite(blip, self.Sprite)
    SetBlipScale(blip, self.Scale)
    SetBlipColour(blip, self.Color)
    SetBlipAlpha(blip, self.Opacity)
    SetBlipAsShortRange(blip, self.ShortRange)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(self.Name)
    EndTextCommandSetBlipName(blip)
    self.Handle = blip
end

-- Commande pour créer un blip à la position du joueur
RegisterCommand("createblip", function()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local newBlip = BlipClass:new(playerCoords)
    newBlip:create()
end, false)
