local Games = {
    {id = nil, load = "https://raw.githubusercontent.com/dementiaenjoyer/eclipse.lol/main/universal.lua"},
}

function Load(array)
    loadstring(game:HttpGet(array.load))()
end

if not (getgenv().Load_DaHood) then
    for i, CheckTable in ipairs(Games) do
        if CheckTable.id == game.GameId and CheckTable.load ~= nil then
            Load(CheckTable)
        elseif CheckTable.id == nil and CheckTable.load ~= nil then
            Load(CheckTable)
        end
    end
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dementiaenjoyer/eclipse.lol/main/da%20hood.lua"))()
end
