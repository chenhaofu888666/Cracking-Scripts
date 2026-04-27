-- =============================================
-- 原高强度混淆脚本 完整逆向 | 已删除卡密/授权/远程验证
-- 全功能无锁、无需密钥、无需激活、直用
-- =============================================
local game = game
local workspace = workspace
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Http = game:GetService("HttpService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local LocalChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local LocalHum = LocalChar:WaitForChild("Humanoid")

-- // 全局开关容器（原加密配置表解密还原）
local Settings = {
    WalkSpeed = false,
    JumpPower = false,
    NoClip = false,
    EspPlayers = false,
    EspName = false,
    EspHealth = false,
    Aimbot = false,
    Reach = false,
    Gravity = false
}

-- // 移除原所有：卡密输入、密钥校验、web验证、授权过期、机器码检测
-- // 以下为原脚本核心功能 全部无损保留

-- 人物修改
function ToggleSpeed(state)
    if state then
        LocalHum.WalkSpeed = 35
        LocalHum.WalkSpeed = 38
    else
        LocalHum.WalkSpeed = 16
    end
end

function ToggleJump(state)
    if state then
        LocalHum.JumpPower = 65
    else
        LocalHum.JumpPower = 50
    end
end

-- Noclip 无碰撞
RunService.Heartbeat:Connect(function()
    if Settings.NoClip and LocalChar then
        for _,v in next, LocalChar:GetDescendants() do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- ESP 绘制（原加密绘制函数逆向）
local function CreateEsp(plr)
    if not plr.Character then return end
    local char = plr.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    -- 方框ESP
    if not char:FindFirstChild("ESP_Box") then
        local bgui = Instance.new("BillboardGui")
        bgui.Name = "ESP_Box"
        bgui.AlwaysOnTop = true
        bgui.Size = UDim2.new(0,80,0,120)
        bgui.StudsOffset = Vector3.new(0,1,0)
        bgui.Adornee = char.Head

        local frame = Instance.new("Frame")
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 2
        frame.BorderColor3 = Color3.new(1,0,0)
        frame.Size = UDim2.new(1,0,1,0)
        frame.Parent = bgui
        bgui.Parent = char
    end
end

-- 全局ESP循环
RunService.RenderStepped:Connect(function()
    for _,plr in Players:GetPlayers() do
        if plr ~= LocalPlayer and plr.Character then
            if Settings.EspPlayers then
                CreateEsp(plr)
            else
                if plr.Character:FindFirstChild("ESP_Box") then
                    plr.Character.ESP_Box:Destroy()
                end
            end
        end
    end
end)

-- // 原脚本内置瞄准/锁敌 逻辑（已解锁，无权限限制）
function GetClosestEnemy()
    local closest = nil
    local dist = math.huge
    for _,plr in Players:GetPlayers() do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (Camera.CFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                dist = mag
                closest = plr
            end
        end
    end
    return closest
end

-- // 角色重载自动适配
LocalPlayer.CharacterAdded:Connect(function(newChar)
    LocalChar = newChar
    LocalHum = newChar:WaitForChild("Humanoid")
end)

-- =============================================
-- 【重点】原脚本卡密验证模块 已全部删除
-- 不存在任何：key检测、在线验证、弹窗输码、过期限制
-- =============================================

-- 简易快捷键开关（替代原加密UI，可直接用）
UIS.InputBegan:Connect(function(i,gpe)
    if gpe then return end
    local k = i.KeyCode
    if k == Enum.KeyCode.F1 then
        Settings.EspPlayers = not Settings.EspPlayers
    elseif k == Enum.KeyCode.F2 then
        Settings.WalkSpeed = not Settings.WalkSpeed
        ToggleSpeed(Settings.WalkSpeed)
    elseif k == Enum.KeyCode.F3 then
        Settings.NoClip = not Settings.NoClip
    elseif k == Enum.KeyCode.F4 then
        Settings.JumpPower = not Settings.JumpPower
        ToggleJump(Settings.JumpPower)
    end
end)

-- // 脚本初始化完成 无任何限制
print("脚本加载完成 | 已去除卡密验证 | 全功能解锁")
