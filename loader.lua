local Games = {
    {id = 2788229376, load = nil},
    {id = nil, load = "https://raw.githubusercontent.com/dementiaenjoyer/eclipse.lol/main/universal.lua"},
}

function Load(array)
    loadstring(game:HttpGet(array.load))()
end

for i, CheckTable in ipairs(Games) do
    if CheckTable.id == game.GameId and CheckTable.load ~= nil then
        Load(CheckTable)
    elseif CheckTable.id == nil and CheckTable.load ~= nil then
        Load(CheckTable)
    end
end
