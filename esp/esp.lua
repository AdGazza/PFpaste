while not game:IsLoaded() do
   wait()
end

local pfId = 292439477
local pId = game.PlaceId
local is_pf = pfId == pId
assert(is_pf, "Phantom Forces Only")
local plr = game.Players.LocalPlayer
local l_character = plr.Character or plr.CharacterAdded:wait()
local o_plrs = workspace:WaitForChild("Players")
local f_team
local e_team
local e_plrlist
local rs = game:GetService("RunService")
local camera = workspace.CurrentCamera


while config.esp.chams do
 wait(100)
   f_team = plr.Team
   for i,v in next, game:GetService("Teams"):GetChildren() do
       if v ~= f_team then
           e_team = v
           break
       end
   end
end

local function geteplrlist()
   for i,v in next, o_plrs:GetChildren() do
       if v.Name == tostring(e_team.TeamColor) then
           return v
       end
   end
end

while config.esp.chams do
 wait(100)
e_plrlist = geteplrlist()
end

local function check_for_esp(c_model)
   returnv = false
   for i,v in next, c_model:GetDescendants() do
       if v:IsA("BoxHandleAdornment") then
           returnv = true
           break
       end
   end
   return returnv
end

local function remove_esp(c_model)
   for i,v in next, c_model:GetDescendants() do
       if v:IsA("BoxHandleAdornment") then
           v:Destroy()
       end
   end
end




local function cast_ray(body_part)
   local rp = RaycastParams.new()
   rp.FilterDescendantsInstances = l_character:GetDescendants()
   rp.FilterType = Enum.RaycastFilterType.Blacklist
   
   local rcr = workspace:Raycast(camera.CFrame.Position, (body_part.Position - camera.CFrame.Position).Unit * 15000,rp)
   if rcr and rcr.Instance == body_part then
       return true
   else
       return false
   end
end

local function create_esp(c_model)
   if check_for_esp(c_model) then
       remove_esp(c_model)
   else
       for i,v in next, c_model:GetChildren() do
           if v:IsA("BasePart") then
               local b = Instance.new("BoxHandleAdornment")
               b.Parent = v
               b.Adornee = v
               b.AlwaysOnTop = true
               b.Size = v.Size
               b.ZIndex = 2
               if cast_ray(v) then
                   b.Color3 = Color3.fromRGB(0,255,0)
               else
                   b.Color3 = Color3.fromRGB(255,0,0)
               end
           end
       end
   end
end

setfpscap(10000)

while config.esp.chams do
   for i,v in next, e_plrlist:GetChildren() do
       create_esp(v)
   end
end
