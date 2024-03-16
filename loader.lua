local Games = {
    {id = nil, load = "https://raw.githubusercontent.com/dementiaenjoyer/eclipse.lol/main/universal.lua"},
    {id = 292439477, load = "https://raw.githubusercontent.com/dementiaenjoyer/eclipse.lol/main/phantom%20forces.lua"},
}

function Load(data)
    loadstring(game:HttpGet(data.load))()
end

if not (getgenv().Load_DaHood) then
    for i, CheckTable in ipairs(Games) do
        if CheckTable.id == game.PlaceId and CheckTable.load ~= nil then
            Load(CheckTable)
            break
        end
    end
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dementiaenjoyer/eclipse.lol/main/da%20hood.lua"))()
end
