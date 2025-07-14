local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPack = game:GetService("StarterPack")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local backpack = player:WaitForChild("Backpack")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ItensGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

local button = Instance.new("TextButton")
button.Name = "PegarButton"
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0, 10)
button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Text = "Pegar Itens"
button.Parent = mainFrame

local itensFrame = Instance.new("Frame")
itensFrame.Name = "ItensFrame"
itensFrame.Size = UDim2.new(1, -20, 1, -70)
itensFrame.Position = UDim2.new(0, 10, 0, 60)
itensFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
itensFrame.BorderSizePixel = 0
itensFrame.Parent = mainFrame
itensFrame.Visible = false

local scrolling = Instance.new("ScrollingFrame")
scrolling.Name = "ScrollingItens"
scrolling.Size = UDim2.new(1, 0, 1, 0)
scrolling.BackgroundTransparency = 1
scrolling.ScrollBarThickness = 8
scrolling.Parent = itensFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = scrolling
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Buscar todas Tools em pastas acessíveis
local function buscarTools(pasta)
	local encontrados = {}
	for _, item in pairs(pasta:GetDescendants()) do
		if item:IsA("Tool") then
			table.insert(encontrados, item)
		end
	end
	return encontrados
end

-- Limpa GUI
local function limparLista()
	for _, child in pairs(scrolling:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end
end

-- Exibe lista de ferramentas
local function mostrarItens(itens)
	limparLista()
	for _, tool in ipairs(itens) do
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -10, 0, 25)
		label.BackgroundTransparency = 0.5
		label.BackgroundColor3 = Color3.fromRGB(40,40,40)
		label.TextColor3 = Color3.new(1,1,1)
		label.Font = Enum.Font.SourceSans
		label.TextSize = 18
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = tool.Name
		label.Parent = scrolling
	end
end

-- Clonar Tool completa (com scripts e tudo)
local function clonarToolCompleta(tool)
	local clone = tool:Clone()
	clone.Parent = backpack
end

-- Pegar todas tools acessíveis
local function pegarItens()
	local todasTools = {}
	local lugares = {
		Workspace,
		ReplicatedStorage,
		StarterPack,
		ReplicatedFirst,
	}

	for _, lugar in ipairs(lugares) do
		local encontrados = buscarTools(lugar)
		for _, tool in ipairs(encontrados) do
			-- Só adiciona se não tiver na mochila ainda
			if not backpack:FindFirstChild(tool.Name) then
				clonarToolCompleta(tool)
				table.insert(todasTools, tool)
			end
		end
	end

	-- Exibe
	if #todasTools == 0 then
		limparLista()
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -10, 0, 25)
		label.BackgroundTransparency = 0.5
		label.BackgroundColor3 = Color3.fromRGB(40,40,40)
		label.TextColor3 = Color3.new(1,1,1)
		label.Font = Enum.Font.SourceSans
		label.TextSize = 18
		label.Text = "Nenhum Tool encontrado."
		label.Parent = scrolling
	else
		mostrarItens(todasTools)
	end

	itensFrame.Visible = true
end

button.MouseButton1Click:Connect(pegarItens)
