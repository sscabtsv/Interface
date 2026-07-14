local cloneref = cloneref or function(object)
  return object
end
if typeof(cloneref) ~= 'function' then
    return warn('Support Issue.')
end

local UserInputService = cloneref(game:GetService('UserInputService'))
local TweenService = cloneref(game:GetService('TweenService'))
local RunService = cloneref(game:GetService('RunService'))
local Workspace = cloneref(game:GetService('Workspace'))
local CoreGui = cloneref(game:GetService('CoreGui'))
local Players = cloneref(game:GetService('Players'))
local HttpService = cloneref(game:GetService('HttpService'))

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlaceId = game.PlaceId

local Library = {
    Flags = {},
    Control_Objects = {},
    Tabs = {},
    Tab_Buttons = {},
    Tab_Icons = {},
    Search_Items = {},
    Saved_Config = {},
    Active_Tab = 1,
    Visible = true,
    Minimized = false,
    Tweening = false,
    Auto_Debounce = false,
    Save_Dirty = false,
    Loading = false,
    Open_Dropdown = nil,
    Capturing = nil,
    Switching = false,
    Searching = false,
    Active_Theme_Name = 'Crimson',
    Active_Font_Name = 'Montserrat',
    Active_Config_Name = 'Default',
    Auto_Resize_Enabled = false,
    Notify_Position = 'Down-Right',
    Notify_Volume = 0.5,
    Notify_Sound = 'Huh',
    Notify_Translate_Enabled = false,
    Notify_Translate_Language = 'English',
}
Library.__index = Library

function Library:exist()
    if not self.Gui then
        return
    end
    if not self.Gui.Parent then
        return
    end
    return true
end

if getgenv then
    getgenv().Ancapri_Loaded = true
end

local Device = {
    ['Mobile'] = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled,
}

local Panel_Min_Width = 600
local Panel_Min_Height = 300
local Panel_Max_Width = 1000
local Panel_Max_Height = 700

local File_Support = pcall(function()
    if not isfolder('Ancapri') then
        makefolder('Ancapri')
    end
end)

Library.Themes = {
    ['Crimson'] = {
        Accent = Color3.fromRGB(203, 104, 118),
        Accent_Hover = Color3.fromRGB(220, 120, 134),
        Accent_Muted = Color3.fromRGB(30, 16, 20),
        Panel = Color3.fromRGB(12, 12, 14),
        Panel_2 = Color3.fromRGB(17, 17, 20),
        Panel_3 = Color3.fromRGB(23, 23, 28),
        Border = Color3.fromRGB(45, 45, 52),
        Text = Color3.fromRGB(232, 232, 240),
        Muted = Color3.fromRGB(144, 144, 160),
        Dim = Color3.fromRGB(96, 96, 112),
        Not_Enabled = Color3.fromRGB(26, 26, 30),
        White = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(96, 200, 140),
        Warning = Color3.fromRGB(230, 188, 64),
        Error = Color3.fromRGB(220, 90, 100),
    },
    ['Azure'] = {
        Accent = Color3.fromRGB(94, 150, 220),
        Accent_Hover = Color3.fromRGB(120, 172, 235),
        Accent_Muted = Color3.fromRGB(16, 22, 32),
        Panel = Color3.fromRGB(10, 13, 17),
        Panel_2 = Color3.fromRGB(15, 19, 25),
        Panel_3 = Color3.fromRGB(20, 26, 33),
        Border = Color3.fromRGB(38, 47, 58),
        Text = Color3.fromRGB(228, 234, 242),
        Muted = Color3.fromRGB(138, 150, 166),
        Dim = Color3.fromRGB(90, 102, 118),
        Not_Enabled = Color3.fromRGB(21, 27, 34),
        White = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(96, 200, 140),
        Warning = Color3.fromRGB(230, 188, 64),
        Error = Color3.fromRGB(220, 90, 100),
    },
    ['Emerald'] = {
        Accent = Color3.fromRGB(96, 190, 140),
        Accent_Hover = Color3.fromRGB(116, 208, 158),
        Accent_Muted = Color3.fromRGB(14, 26, 20),
        Panel = Color3.fromRGB(10, 14, 12),
        Panel_2 = Color3.fromRGB(15, 20, 18),
        Panel_3 = Color3.fromRGB(20, 27, 24),
        Border = Color3.fromRGB(38, 50, 44),
        Text = Color3.fromRGB(226, 238, 232),
        Muted = Color3.fromRGB(136, 156, 146),
        Dim = Color3.fromRGB(90, 108, 100),
        Not_Enabled = Color3.fromRGB(20, 28, 24),
        White = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(96, 200, 140),
        Warning = Color3.fromRGB(230, 188, 64),
        Error = Color3.fromRGB(220, 90, 100),
    },
    ['Violet'] = {
        Accent = Color3.fromRGB(168, 128, 224),
        Accent_Hover = Color3.fromRGB(186, 148, 236),
        Accent_Muted = Color3.fromRGB(24, 18, 32),
        Panel = Color3.fromRGB(12, 11, 15),
        Panel_2 = Color3.fromRGB(18, 16, 22),
        Panel_3 = Color3.fromRGB(24, 21, 29),
        Border = Color3.fromRGB(46, 42, 55),
        Text = Color3.fromRGB(232, 228, 240),
        Muted = Color3.fromRGB(148, 142, 162),
        Dim = Color3.fromRGB(98, 92, 114),
        Not_Enabled = Color3.fromRGB(26, 23, 32),
        White = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(96, 200, 140),
        Warning = Color3.fromRGB(230, 188, 64),
        Error = Color3.fromRGB(220, 90, 100),
    },
    ['Slate'] = {
        Accent = Color3.fromRGB(150, 160, 172),
        Accent_Hover = Color3.fromRGB(170, 180, 192),
        Accent_Muted = Color3.fromRGB(22, 24, 27),
        Panel = Color3.fromRGB(13, 14, 15),
        Panel_2 = Color3.fromRGB(18, 19, 21),
        Panel_3 = Color3.fromRGB(24, 25, 27),
        Border = Color3.fromRGB(46, 48, 51),
        Text = Color3.fromRGB(230, 232, 234),
        Muted = Color3.fromRGB(142, 146, 152),
        Dim = Color3.fromRGB(96, 100, 106),
        Not_Enabled = Color3.fromRGB(25, 26, 28),
        White = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(96, 200, 140),
        Warning = Color3.fromRGB(230, 188, 64),
        Error = Color3.fromRGB(220, 90, 100),
    },
    ['Sunset'] = {
        Accent = Color3.fromRGB(230, 150, 90),
        Accent_Hover = Color3.fromRGB(240, 170, 112),
        Accent_Muted = Color3.fromRGB(32, 22, 15),
        Panel = Color3.fromRGB(15, 12, 11),
        Panel_2 = Color3.fromRGB(21, 17, 15),
        Panel_3 = Color3.fromRGB(28, 23, 20),
        Border = Color3.fromRGB(54, 44, 38),
        Text = Color3.fromRGB(240, 232, 226),
        Muted = Color3.fromRGB(160, 144, 132),
        Dim = Color3.fromRGB(112, 98, 88),
        Not_Enabled = Color3.fromRGB(30, 25, 22),
        White = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(96, 200, 140),
        Warning = Color3.fromRGB(230, 188, 64),
        Error = Color3.fromRGB(220, 90, 100),
    },
    ['Monochrome'] = {
        Accent = Color3.fromRGB(224, 224, 224),
        Accent_Hover = Color3.fromRGB(240, 240, 240),
        Accent_Muted = Color3.fromRGB(26, 26, 26),
        Panel = Color3.fromRGB(10, 10, 10),
        Panel_2 = Color3.fromRGB(16, 16, 16),
        Panel_3 = Color3.fromRGB(22, 22, 22),
        Border = Color3.fromRGB(44, 44, 44),
        Text = Color3.fromRGB(235, 235, 235),
        Muted = Color3.fromRGB(150, 150, 150),
        Dim = Color3.fromRGB(100, 100, 100),
        Not_Enabled = Color3.fromRGB(24, 24, 24),
        White = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(180, 180, 180),
        Warning = Color3.fromRGB(210, 210, 210),
        Error = Color3.fromRGB(150, 150, 150),
    },
}

local Theme = {}
for Key, Value in pairs(Library.Themes[Library.Active_Theme_Name]) do
    Theme[Key] = Value
end

local Custom_Themes = {}

local Badge_Colors = {
    Hot = {
        Background = Color3.fromRGB(50, 20, 25),
        Text = Color3.fromRGB(203, 104, 118),
        Border = Color3.fromRGB(100, 40, 50),
    },
    New = {
        Background = Color3.fromRGB(16, 46, 36),
        Text = Color3.fromRGB(96, 212, 160),
        Border = Color3.fromRGB(40, 110, 80),
    },
    Beta = {
        Background = Color3.fromRGB(32, 22, 55),
        Text = Color3.fromRGB(176, 136, 238),
        Border = Color3.fromRGB(80, 56, 140),
    },
    Risky = {
        Background = Color3.fromRGB(54, 42, 12),
        Text = Color3.fromRGB(230, 188, 64),
        Border = Color3.fromRGB(120, 92, 30),
    },
}

local Spring_Style = Enum.EasingStyle.Back
local Spring_Direction = Enum.EasingDirection.Out

local Font_Families = {
    ["Arial"] = "rbxasset://fonts/families/Arial.json",
    ["ArialRoundedMTBold"] = "rbxasset://fonts/families/ArialRoundedMTBold.json",
    ["Arimo"] = "rbxasset://fonts/families/Arimo.json",
    ["Bangers"] = "rbxasset://fonts/families/Bangers.json",
    ["BuilderSans"] = "rbxasset://fonts/families/BuilderSans.json",
    ["Cartoon"] = "rbxasset://fonts/families/Cartoon.json",
    ["Code"] = "rbxasset://fonts/families/Code.json",
    ["Creepster"] = "rbxasset://fonts/families/Creepster.json",
    ["FredokaOne"] = "rbxasset://fonts/families/FredokaOne.json",
    ["Garamond"] = "rbxasset://fonts/families/Garamond.json",
    ["Gotham"] = "rbxasset://fonts/families/GothamSSm.json",
    ["GrenzeGotisch"] = "rbxasset://fonts/families/GrenzeGotisch.json",
    ["Highway"] = "rbxasset://fonts/families/Highway.json",
    ["Inconsolata"] = "rbxasset://fonts/families/Inconsolata.json",
    ["IndieFlower"] = "rbxasset://fonts/families/IndieFlower.json",
    ["JosefinSans"] = "rbxasset://fonts/families/JosefinSans.json",
    ["Jura"] = "rbxasset://fonts/families/Jura.json",
    ["Kalam"] = "rbxasset://fonts/families/Kalam.json",
    ["LegacyArial"] = "rbxasset://fonts/families/LegacyArial.json",
    ["LegacyArialBold"] = "rbxasset://fonts/families/LegacyArialBold.json",
    ["LegacySourceSans"] = "rbxasset://fonts/families/LegacySourceSans.json",
    ["Michroma"] = "rbxasset://fonts/families/Michroma.json",
    ["Montserrat"] = "rbxasset://fonts/families/Montserrat.json",
    ["MuseoModerno"] = "rbxasset://fonts/families/MuseoModerno.json",
    ["Nunito"] = "rbxasset://fonts/families/Nunito.json",
    ["Oswald"] = "rbxasset://fonts/families/Oswald.json",
    ["PatrickHand"] = "rbxasset://fonts/families/PatrickHand.json",
    ["PermanentMarker"] = "rbxasset://fonts/families/PermanentMarker.json",
    ["PressStart2P"] = "rbxasset://fonts/families/PressStart2P.json",
    ["Roboto"] = "rbxasset://fonts/families/Roboto.json",
    ["RobotoCondensed"] = "rbxasset://fonts/families/RobotoCondensed.json",
    ["RobotoMono"] = "rbxasset://fonts/families/RobotoMono.json",
    ["Sarpanch"] = "rbxasset://fonts/families/Sarpanch.json",
    ["SciFi"] = "rbxasset://fonts/families/SciFi.json",
    ["SourceSansPro"] = "rbxasset://fonts/families/SourceSansPro.json",
    ["SpecialElite"] = "rbxasset://fonts/families/SpecialElite.json",
    ["TitilliumWeb"] = "rbxasset://fonts/families/TitilliumWeb.json",
    ["Ubuntu"] = "rbxasset://fonts/families/Ubuntu.json",
    ["Unknown"] = "rbxasset://fonts/families/Unknown.json",
}
local Font_Family_Order = {
    "Arial",
    "ArialRoundedMTBold",
    "Arimo",
    "Bangers",
    "BuilderSans",
    "Cartoon",
    "Code",
    "Creepster",
    "FredokaOne",
    "Garamond",
    "Gotham",
    "GrenzeGotisch",
    "Highway",
    "Inconsolata",
    "IndieFlower",
    "JosefinSans",
    "Jura",
    "Kalam",
    "LegacyArial",
    "LegacyArialBold",
    "LegacySourceSans",
    "Michroma",
    "Montserrat",
    "MuseoModerno",
    "Nunito",
    "Oswald",
    "PatrickHand",
    "PermanentMarker",
    "PressStart2P",
    "Roboto",
    "RobotoCondensed",
    "RobotoMono",
    "Sarpanch",
    "SciFi",
    "SourceSansPro",
    "SpecialElite",
    "TitilliumWeb",
    "Ubuntu",
    "Unknown",
}

local Theme_Bindings = {}
local Font_Bindings = {}
local Theme_Refresh_Callbacks = {}
local Current_Instance = nil

local Theme_Token_Meta = {}
local Font_Token_Meta = {}

local function Theme_Ref(Key)
    return setmetatable({Key = Key}, Theme_Token_Meta)
end

local function Font_Ref(Weight)
    return setmetatable({Weight = Weight}, Font_Token_Meta)
end

local function Register_Theme_Refresh(Object, Run_Function)
    table.insert(Theme_Refresh_Callbacks, {
        Alive = function() return Object ~= nil and Object.Parent ~= nil end,
        Run = Run_Function,
    })
end

local function Create_Instance(Class_Name, Properties, Parent)
    local Object = Instance.new(Class_Name)
    for Key, Value in pairs(Properties) do
        if type(Value) == 'table' and getmetatable(Value) == Theme_Token_Meta then
            Object[Key] = Theme[Value.Key]
            table.insert(Theme_Bindings, {Object = Object, Property = Key, Theme_Key = Value.Key})
        elseif type(Value) == 'table' and getmetatable(Value) == Font_Token_Meta then
            Object[Key] = Font.new(Font_Families[Library.Active_Font_Name], Value.Weight)
            table.insert(Font_Bindings, {Object = Object, Property = Key, Weight = Value.Weight})
        else
            Object[Key] = Value
        end
    end
    if Parent then Object.Parent = Parent end
    return Object
end

local function Create_Tween(Object, Duration, Properties, Easing_Style, Easing_Direction)
    local Tween_Info = TweenInfo.new(Duration, Easing_Style or Enum.EasingStyle.Quint, Easing_Direction or Enum.EasingDirection.Out)
    local Tween_Object = TweenService:Create(Object, Tween_Info, Properties)
    Tween_Object:Play()
    return Tween_Object
end

local function Create_Corner(Parent, Radius)
    return Create_Instance('UICorner', {
        CornerRadius = UDim.new(0, Radius or 8),
    }, Parent)
end

local function Create_Sound(Parent, Id, Volume)
    return Create_Instance('Sound', {
        Name = 'ASoundFromAncapri',
        SoundId = 'rbxassetid://' .. tostring(Id),
        Volume = Volume or 0.5,
    }, Parent)
end

local function Create_Stroke(Parent, Theme_Key, Thickness, Transparency)
    return Create_Instance('UIStroke', {
        Color = Theme_Ref(Theme_Key or 'Border'),
        Thickness = Thickness or 1,
        Transparency = Transparency or 0,
    }, Parent)
end

local function Color_To_Hex(Color)
    return string.format('#%02X%02X%02X', math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), math.floor(Color.B * 255 + 0.5))
end

local function Hex_To_Color(Hex)
    Hex = tostring(Hex):gsub('#', '')
    if #Hex ~= 6 then return nil end
    local Red = tonumber(Hex:sub(1, 2), 16)
    local Green = tonumber(Hex:sub(3, 4), 16)
    local Blue = tonumber(Hex:sub(5, 6), 16)
    if Red and Green and Blue then
        return Color3.fromRGB(Red, Green, Blue)
    end
    return nil
end

local function Apply_Theme(New_Theme_Data, Theme_Name, Instant)
    for Key, Value in pairs(New_Theme_Data) do
        Theme[Key] = Value
    end
    if Theme_Name then
        Library.Active_Theme_Name = Theme_Name
    end

    local Remaining_Bindings = {}
    for _, Binding in ipairs(Theme_Bindings) do
        local Object = Binding.Object
        if Object and Object.Parent then
            local Target_Color = Theme[Binding.Theme_Key]
            if Target_Color ~= nil then
                if Instant then
                    pcall(function() Object[Binding.Property] = Target_Color end)
                else
                    pcall(function()
                        Create_Tween(Object, 0.35, {[Binding.Property] = Target_Color}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                    end)
                end
            end
            table.insert(Remaining_Bindings, Binding)
        end
    end
    Theme_Bindings = Remaining_Bindings

    local Remaining_Callbacks = {}
    for _, Callback_Data in ipairs(Theme_Refresh_Callbacks) do
        if Callback_Data.Alive() then
            pcall(Callback_Data.Run)
            table.insert(Remaining_Callbacks, Callback_Data)
        end
    end
    Theme_Refresh_Callbacks = Remaining_Callbacks

    if Current_Instance then
        Current_Instance:Status('Theme applied: ' .. tostring(Theme_Name or 'Custom'), Theme.Accent, 1.6)
    end
end

local function Apply_Font(New_Font_Name)
    if not Font_Families[New_Font_Name] then return end
    Library.Active_Font_Name = New_Font_Name

    local Remaining_Bindings = {}
    for _, Binding in ipairs(Font_Bindings) do
        local Object = Binding.Object
        if Object and Object.Parent then
            pcall(function()
                Object[Binding.Property] = Font.new(Font_Families[New_Font_Name], Binding.Weight)
            end)
            table.insert(Remaining_Bindings, Binding)
        end
    end
    Font_Bindings = Remaining_Bindings

    if Current_Instance then
        Current_Instance:Status('Font applied: ' .. New_Font_Name, Theme.Accent, 1.6)
    end
end

local function Ensure_Folders()
    pcall(function()
        if not isfolder('Ancapri') then
            makefolder('Ancapri')
        end
        if not isfolder('Ancapri/Data') then
            makefolder('Ancapri/Data')
        end
        if not isfolder('Ancapri/Data/Configs') then
            makefolder('Ancapri/Data/Configs')
        end
        if not isfolder('Ancapri/Data/Configs/' .. tostring(PlaceId)) then
            makefolder('Ancapri/Data/Configs/' .. tostring(PlaceId))
        end
        if not isfolder('Ancapri/Data/Themes') then
            makefolder('Ancapri/Data/Themes')
        end
    end)
end

local function Sanitize_File_Name(Name)
    Name = tostring(Name or '')
    Name = Name:gsub('[^%w%s%-_]', '')
    Name = Name:gsub('^%s+', ''):gsub('%s+$', '')
    if Name == '' then Name = 'Default' end
    return Name
end

local function Get_Config_Folder()
    return 'Ancapri/Data/Configs/' .. tostring(PlaceId)
end

local function Get_Config_Path(Name)
    return Get_Config_Folder() .. '/' .. Sanitize_File_Name(Name) .. '.json'
end

local function Get_Theme_Path(Name)
    return 'Ancapri/Data/Themes/' .. Sanitize_File_Name(Name) .. '.json'
end

local function Encode_Flag_Value(Value)
    if typeof(Value) == 'Color3' then
        return {Ancapri_Type = 'color3', Hex = Color_To_Hex(Value)}
    end
    return Value
end

local function Decode_Flag_Value(Value)
    if type(Value) == 'table' and Value.Ancapri_Type == 'color3' then
        return Hex_To_Color(Value.Hex) or Color3.new(1, 1, 1)
    end
    return Value
end

local function Save_Config(Name, Flags)
    Ensure_Folders()
    local Export = {}
    for Flag, Value in pairs(Flags) do
        Export[Flag] = Encode_Flag_Value(Value)
    end
    local Encode_Success, Encoded = pcall(function()
        return HttpService:JSONEncode(Export)
    end)
    if not Encode_Success then return false end
    return pcall(writefile, Get_Config_Path(Name), Encoded)
end

local function Load_Config(Name)
    local Success, Result = pcall(function()
        local Path = Get_Config_Path(Name)
        if isfile(Path) then
            local Raw = readfile(Path)
            local Decoded = HttpService:JSONDecode(Raw)
            local Import = {}
            for Flag, Value in pairs(Decoded) do
                Import[Flag] = Decode_Flag_Value(Value)
            end
            return Import
        end
        return nil
    end)
    if Success and type(Result) == 'table' then
        return Result
    end
    return nil
end

local function Delete_Config(Name)
    return pcall(function()
        local Path = Get_Config_Path(Name)
        if isfile(Path) then
            delfile(Path)
        end
    end)
end

local function List_Configs()
    local Names = {}
    pcall(function()
        Ensure_Folders()
        local Files = listfiles(Get_Config_Folder())
        for _, Full_Path in ipairs(Files) do
            local File_Name = Full_Path:match('([^\\/]+)%.json$')
            if File_Name then
                table.insert(Names, File_Name)
            end
        end
    end)
    table.sort(Names, function(A, B) return A:lower() < B:lower() end)
    if #Names == 0 then
        table.insert(Names, 'Default')
    end
    return Names
end

local function Save_Theme(Name, Theme_Data)
    Ensure_Folders()
    local Export = {}
    for Key, Value in pairs(Theme_Data) do
        if typeof(Value) == 'Color3' then
            Export[Key] = Color_To_Hex(Value)
        end
    end
    local Encode_Success, Encoded = pcall(function()
        return HttpService:JSONEncode(Export)
    end)
    if not Encode_Success then return false end
    return pcall(writefile, Get_Theme_Path(Name), Encoded)
end

local function Load_Theme(Name)
    local Success, Result = pcall(function()
        local Path = Get_Theme_Path(Name)
        if isfile(Path) then
            local Raw = readfile(Path)
            local Decoded = HttpService:JSONDecode(Raw)
            local Import = {}
            for Key, Value in pairs(Decoded) do
                local Color = Hex_To_Color(Value)
                if Color then
                    Import[Key] = Color
                end
            end
            return Import
        end
        return nil
    end)
    if Success and type(Result) == 'table' then
        return Result
    end
    return nil
end

local function Delete_Theme(Name)
    return pcall(function()
        local Path = Get_Theme_Path(Name)
        if isfile(Path) then
            delfile(Path)
        end
        Custom_Themes[Name] = nil
    end)
end

local function List_Custom_Themes()
    local Names = {}
    pcall(function()
        Ensure_Folders()
        local Files = listfiles('Ancapri/Data/Themes')
        for _, Full_Path in ipairs(Files) do
            local File_Name = Full_Path:match('([^\\/]+)%.json$')
            if File_Name then
                table.insert(Names, File_Name)
            end
        end
    end)
    table.sort(Names, function(A, B) return A:lower() < B:lower() end)
    return Names
end

local function All_Theme_Names()
    local Names = {}
    local Builtin_Order = {'Crimson', 'Azure', 'Emerald', 'Violet', 'Slate', 'Sunset', 'Monochrome'}
    for _, Name in ipairs(Builtin_Order) do
        table.insert(Names, Name)
    end
    for _, Name in ipairs(List_Custom_Themes()) do
        table.insert(Names, Name)
    end
    return Names
end

local Notify_Kind_Colors = {
    Info = 'Accent',
    Success = 'Success',
    Warning = 'Warning',
    Error = 'Error',
}

local Notify_Sound_Ids = {
    ['Eh'] = 'rbxassetid://105117264394463',
    ['Huh'] = 'rbxassetid://18548307445',
    ['Uwu'] = 'rbxassetid://124356179581089',
    ['MGS5'] = 'rbxassetid://654933978',
    ['Meow'] = 'rbxassetid://134699420140804',
    ['Soft Ping'] = 'rbxassetid://133118130342644',
    ['Windows 8'] = 'rbxassetid://1862045322',
    ['Old Discord'] = 'rbxassetid://91271439961236',
}

local Notify_Sound_Order = {'Eh', 'Huh', 'Uwu', 'MGS5', 'Meow', 'Soft Ping', 'Windows 8', 'Old Discord'}

local Notify_Position_Map = {
    ['Down-Right'] = {Anchor = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16), Vertical = Enum.VerticalAlignment.Bottom},
    ['Down-Left'] = {Anchor = Vector2.new(0, 1), Position = UDim2.new(0, 16, 1, -16), Vertical = Enum.VerticalAlignment.Bottom},
    ['Up-Right'] = {Anchor = Vector2.new(1, 0), Position = UDim2.new(1, -16, 0, 16), Vertical = Enum.VerticalAlignment.Top},
    ['Up-Left'] = {Anchor = Vector2.new(0, 0), Position = UDim2.new(0, 16, 0, 16), Vertical = Enum.VerticalAlignment.Top},
    ['Down-Center'] = {Anchor = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -16), Vertical = Enum.VerticalAlignment.Bottom},
    ['Up-Center'] = {Anchor = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 16), Vertical = Enum.VerticalAlignment.Top},
    ['Mid-Left'] = {Anchor = Vector2.new(0, 0.5), Position = UDim2.new(0, 16, 0.5, 0), Vertical = Enum.VerticalAlignment.Center},
    ['Mid-Right'] = {Anchor = Vector2.new(1, 0.5), Position = UDim2.new(1, -16, 0.5, 0), Vertical = Enum.VerticalAlignment.Center},
}

local Notify_Position_Order = {'Down-Right', 'Down-Left', 'Up-Right', 'Up-Left', 'Down-Center', 'Up-Center', 'Mid-Left', 'Mid-Right'}

local Language_Codes = {
    English = 'en',
    Spanish = 'es',
    Chinese = 'zh-cn',
    Hindi = 'hi',
    Russian = 'ru',
    French = 'fr',
    Portuguese = 'pt',
    Vietnamese = 'vi',
    German = 'de',
    Arabic = 'ar',
}

local Language_Order = {'English', 'Spanish', 'Chinese', 'Hindi', 'Russian', 'French', 'Portuguese', 'Vietnamese', 'German', 'Arabic'}

local function Http_Request(Options)
    local Signal = (syn and syn.request) or (http and http.request) or http_request or request
    if Signal then
        return Signal(Options)
    end
    return HttpService:RequestAsync(Options)
end

local function Translate_Via_Google(Text, Target_Code, Source_Code)
    Source_Code = Source_Code or 'auto'
    local Url = 'https://translate.googleapis.com/translate_a/single?client=gtx&sl=' .. Source_Code .. '&tl=' .. Target_Code .. '&dt=t&q=' .. HttpService:UrlEncode(Text)
    local Ok, Result = pcall(function()
        local Response = Http_Request({Url = Url, Method = 'GET'})
        local Body = Response.Body or Response.body
        local Decoded = HttpService:JSONDecode(Body)
        local Combined_Text = ''
        if Decoded and Decoded[1] then
            for _, Section in ipairs(Decoded[1]) do
                if Section[1] then Combined_Text = Combined_Text .. Section[1] end
            end
        end
        return Combined_Text
    end)
    if Ok and Result and Result ~= '' then
        return Result
    end
    return nil
end

local Translation_Cache = {}

local function Translate_Text(Text)
    if not Current_Instance or not Current_Instance.Notify_Translate_Enabled then return Text end
    if type(Text) ~= 'string' or Text == '' then
        return Text
    end

    local Target_Language = Current_Instance.Notify_Translate_Language or 'English'
    if Target_Language == 'English' or not Language_Codes[Target_Language] then
        return Text
    end

    local Cache_Key = Target_Language .. '|' .. Text
    if Translation_Cache[Cache_Key] then
        return Translation_Cache[Cache_Key]
    end

    local Translated = Translate_Via_Google(Text, Language_Codes[Target_Language])
    if Translated then
        Translation_Cache[Cache_Key] = Translated
        return Translated
    end
    return Text
end

function Library:Init_Notifications()
    local Existing = self.Gui:FindFirstChild('Notify')
    if Existing then Existing:Destroy() end

    local Screen_Gui = Create_Instance('ScreenGui', {
        Name = 'Notify',
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
    }, self.Gui)

    local Edge_Margin = Device['Mobile'] and 12 or 16
    local Initial_Pos = Notify_Position_Map[self.Notify_Position] or Notify_Position_Map['Down-Right']

    local Container = Create_Instance('Frame', {
        Name = 'Container',
        AnchorPoint = Initial_Pos.Anchor,
        Position = Initial_Pos.Position,
        Size = UDim2.fromOffset(300, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 1000,
    }, Screen_Gui)

    local List_Layout = Create_Instance('UIListLayout', {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Initial_Pos.Vertical,
    }, Container)

    self.Notify_Gui = Screen_Gui
    self.Notify_Container = Container
    self.Notify_List_Layout = List_Layout
    self.Notify_Order_Counter = 0
    self.Notify_Active = {}
    self.Notify_Current_Sound = nil

    local Last_Position_Key = self.Notify_Position

    self.Notify_Position_Watcher = task.spawn(function()
        while Container and Container.Parent do
            local Current_Key = self.Notify_Position or 'Down-Right'
            if Current_Key ~= Last_Position_Key then
                local New_Pos = Notify_Position_Map[Current_Key] or Notify_Position_Map['Down-Right']
                Last_Position_Key = Current_Key
                Container.AnchorPoint = New_Pos.Anchor
                List_Layout.VerticalAlignment = New_Pos.Vertical
                Create_Tween(Container, 0.35, {Position = New_Pos.Position}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            end
            task.wait(0.15)
        end
    end)
end

function Library:Notify(Options)
    Options = Options or {}
    if not self.Notify_Container or not self.Notify_Container.Parent then
        self:Init_Notifications()
    end

    local Title = Translate_Text(tostring(Options.Title or 'Notification'))
    local Description = Translate_Text(tostring(Options.Description or ''))
    local Duration = tonumber(Options.Duration) or 5
    local Kind_Key = Notify_Kind_Colors[Options.Kind] or 'Accent'
    local Accent_Color = Theme[Kind_Key] or Theme.Accent
    local Notify_Key = Title .. '|' .. Description

    if self.Notify_Active[Notify_Key] then
        local Previous = self.Notify_Active[Notify_Key]
        self.Notify_Active[Notify_Key] = nil
        local Finished = false
        Previous.Dismiss(function() Finished = true end)
        repeat task.wait() until Finished
        task.wait()
    end

    self.Notify_Order_Counter += 1
    local My_Order = self.Notify_Order_Counter
    local Has_Description = Description ~= ''

    local Card = Create_Instance('Frame', {
        Name = 'Card',
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Panel_2,
        BorderSizePixel = 0,
        LayoutOrder = My_Order,
        ClipsDescendants = true,
        ZIndex = 1001,
    }, self.Notify_Container)

    Create_Corner(Card, 10)
    local Card_Stroke = Create_Instance('UIStroke', {
        Color = Theme.Border,
        Thickness = 1,
        Transparency = 0.35,
    }, Card)

    Create_Instance('UIPadding', {
        PaddingTop = UDim.new(0, 11),
        PaddingBottom = UDim.new(0, 18),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14),
    }, Card)

    local Content = Create_Instance('Frame', {
        Name = 'Content',
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 1002,
    }, Card)

    Create_Instance('UIListLayout', {
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, Content)

    local Title_Row = Create_Instance('Frame', {
        Name = 'Title Row',
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        ZIndex = 1003,
    }, Content)

    Create_Instance('TextLabel', {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        FontFace = Font.new(Font_Families[self.Active_Font_Name], Enum.FontWeight.Bold),
        TextSize = 13,
        Text = Title,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 1003,
    }, Title_Row)

    if Has_Description then
        Create_Instance('TextLabel', {
            Name = 'Description',
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            FontFace = Font.new(Font_Families[self.Active_Font_Name], Enum.FontWeight.Medium),
            TextSize = 12,
            Text = Description,
            TextColor3 = Theme.Muted,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            LineHeight = 1.15,
            LayoutOrder = 2,
            ZIndex = 1003,
        }, Content)
    end

    local Underline_Inset = 10
    local Progress_Track = Create_Instance('Frame', {
        Name = 'Progress',
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, 12),
        Size = UDim2.new(1, -Underline_Inset * 2, 0, 2),
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        ZIndex = 1002,
    }, Card)

    Create_Corner(Progress_Track, 2)

    local Progress_Fill = Create_Instance('Frame', {
        Name = 'Fill',
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Accent_Color,
        BorderSizePixel = 0,
        ZIndex = 1003,
    }, Progress_Track)

    Create_Corner(Progress_Fill, 2)

    if Options.Notify ~= false then
        if self.Notify_Current_Sound then
            local Previous_Sound = self.Notify_Current_Sound
            self.Notify_Current_Sound = nil
            pcall(function() Previous_Sound:Stop() end)
            pcall(function() Previous_Sound:Destroy() end)
        end

        local Sound_Volume = tonumber(self.Notify_Volume) or 0.5
        local Sound_Type = self.Notify_Sound or 'Huh'
        local Sound_Id = Notify_Sound_Ids[Sound_Type] or Notify_Sound_Ids['Huh']

        local Notify_Sound_Object = Create_Instance('Sound', {
            Name = 'NotifySound',
            SoundId = Sound_Id,
            Volume = Sound_Volume * 5,
            PlayOnRemove = false,
        }, Card)

        self.Notify_Current_Sound = Notify_Sound_Object

        Notify_Sound_Object:Play()
        Notify_Sound_Object.Ended:Connect(function()
            if self.Notify_Current_Sound == Notify_Sound_Object then
                self.Notify_Current_Sound = nil
            end
            Notify_Sound_Object:Destroy()
        end)
    end

    local Dismissed = false
    local Notification_Object

    local function Dismiss(On_Complete)
        if Dismissed then
            if On_Complete then On_Complete() end
            return
        end
        Dismissed = true
        if self.Notify_Active[Notify_Key] == Notification_Object then
            self.Notify_Active[Notify_Key] = nil
        end
        Create_Tween(Card, 0.22, {Size = UDim2.new(1, 0, 0, 0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        Create_Tween(Card, 0.20, {BackgroundTransparency = 1})
        Create_Tween(Card_Stroke, 0.20, {Transparency = 1})
        for _, Descendant in ipairs(Card:GetDescendants()) do
            if Descendant:IsA('TextLabel') or Descendant:IsA('TextButton') then
                Create_Tween(Descendant, 0.18, {TextTransparency = 1, BackgroundTransparency = 1})
            elseif Descendant:IsA('Frame') then
                Create_Tween(Descendant, 0.18, {BackgroundTransparency = 1})
            elseif Descendant:IsA('UIStroke') then
                Create_Tween(Descendant, 0.18, {Transparency = 1})
            end
        end
        task.delay(0.24, function()
            if Card and Card.Parent then Card:Destroy() end
            if On_Complete then On_Complete() end
        end)
    end

    Card.Position = UDim2.fromOffset(40, 0)
    Card.BackgroundTransparency = 1
    Card_Stroke.Transparency = 1

    for _, Descendant in ipairs(Content:GetDescendants()) do
        if Descendant:IsA('TextLabel') then
            Descendant.TextTransparency = 1
        end
    end

    Create_Tween(Card, 0.26, {Position = UDim2.fromOffset(0, 0), BackgroundTransparency = 0}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    Create_Tween(Card_Stroke, 0.26, {Transparency = 0.35})

    for _, Descendant in ipairs(Content:GetDescendants()) do
        if Descendant:IsA('TextLabel') then
            Create_Tween(Descendant, 0.22, {TextTransparency = 0})
        end
    end

    task.spawn(function()
        local Elapsed = 0
        while Elapsed < Duration do
            local Delta_Time = task.wait()
            if Dismissed then break end
            Elapsed += Delta_Time
            local Alpha = math.clamp(1 - (Elapsed / Duration), 0, 1)
            if Progress_Fill and Progress_Fill.Parent then
                Progress_Fill.Size = UDim2.fromScale(Alpha, 1)
            end
        end
        if not Dismissed then
            Dismiss()
        end
    end)

    Notification_Object = {
        Dismiss = Dismiss,
        Card = Card,
    }
    self.Notify_Active[Notify_Key] = Notification_Object
    return Notification_Object
end

local Raw_Connections = {}

local Connection = setmetatable({}, {
    __newindex = function(_, Key, Value)
        if Raw_Connections[Key] then
            pcall(function() Raw_Connections[Key]:Disconnect() end)
            Raw_Connections[Key] = nil
        end
        if Value then
            Raw_Connections[Key] = Value
        end
    end,
    __index = function(_, Key)
        return Raw_Connections[Key]
    end,
})

local function Clear_All_Connections()
    for Key, Conn in pairs(Raw_Connections) do
        pcall(function() Conn:Disconnect() end)
        Raw_Connections[Key] = nil
    end
end

function Library:clear()
    Clear_All_Connections()
    for _, Object in ipairs(CoreGui:GetChildren()) do
        if Object.Name == 'Ancapri' then
            Object:Destroy()
        end
    end
end

function Library:Destroy()
    self:clear()
    self.Flags = {}
    self.Control_Objects = {}
    self.Tabs = {}
    self.Tab_Buttons = {}
    self.Tab_Icons = {}
    self.Search_Items = {}
    self.Visible = false
    self.Minimized = false
    self.Tweening = false
    self.Gui = nil
    Theme_Bindings = {}
    Font_Bindings = {}
    Theme_Refresh_Callbacks = {}
    if Current_Instance == self then
        Current_Instance = nil
    end
    if getgenv then
        getgenv().Ancapri_Loaded = false
    end
end

function Library:Status(Message, Color, Duration)
    if not self.Status_Label or not self.Status_Dot then return end
    self.Status_Label.Text = Message
    self.Status_Dot.BackgroundColor3 = Color or Theme.Accent
    task.delay(Duration or 1.6, function()
        if not self.Status_Label or not self.Status_Label.Parent then return end
        if self.Status_Label.Text == Message then
            self.Status_Label.Text = 'Active session running'
            self.Status_Dot.BackgroundColor3 = Theme.Accent
        end
    end)
end

function Library:Set_No_Results(Show)
    if not self.No_Results then return end

    if Show then
        if self.No_Results.Visible then return end

        self.No_Results.Visible = true
        self.No_Results_Image.ImageTransparency = 1
        self.No_Results_Image.Position = UDim2.new(0.5, 0, 0.5, 12)

        self.No_Results_Label.TextTransparency = 1
        self.No_Results_Label.Position = UDim2.new(0.5, 0, 0.5, 38)

        Create_Tween(self.No_Results_Image, 0.28, {
            ImageTransparency = 0,
            Position = UDim2.new(0.5, 0, 0.5, -6),
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

        task.delay(0.13, function()
            if not self.No_Results.Visible then return end
            Create_Tween(self.No_Results_Label, 0.28, {
                TextTransparency = 0,
                Position = UDim2.new(0.5, 0, 0.5, 28),
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end)
    else
        if not self.No_Results.Visible then return end

        Create_Tween(self.No_Results_Image, 0.08, {
            ImageTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 10),
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

        Create_Tween(self.No_Results_Label, 0.08, {
            TextTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 36),
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

        task.delay(0.09, function()
            if self.No_Results then
                self.No_Results.Visible = false
            end
        end)
    end
end

function Library:Search(Query)
    Query = tostring(Query or ''):lower():gsub('^%s*(.-)%s*$', '%1')

    self.Search_Generation = (self.Search_Generation or 0) + 1
    local My_Generation = self.Search_Generation

    local function Refresh_Active_Layout()
        local Pane = self.Tabs[self.Active_Tab]
        if not Pane then return end
        task.spawn(function()
            RunService.Heartbeat:Wait()
            Pane.AutomaticSize = Enum.AutomaticSize.None
            RunService.Heartbeat:Wait()
            Pane.AutomaticSize = Enum.AutomaticSize.Y
            RunService.Heartbeat:Wait()
            if self.Body then
                self.Body.AutomaticCanvasSize = Enum.AutomaticSize.None
                RunService.Heartbeat:Wait()
                self.Body.AutomaticCanvasSize = Enum.AutomaticSize.Y
            end
        end)
    end

    if Query == '' then
        self.Searching = false
        for _, Item in ipairs(self.Search_Items) do
            Item.Object.Visible = true
        end
        Refresh_Active_Layout()
        self:Set_No_Results(false)
        return
    end

    self.Searching = true
    local First_Match_Tab = nil
    local Any_Match = false
    for _, Item in ipairs(self.Search_Items) do
        local Is_Match = string.find(Item.Name:lower(), Query, 1, true) ~= nil
        Item.Object.Visible = Is_Match
        if Is_Match then
            Any_Match = true
            if not First_Match_Tab then
                First_Match_Tab = Item.Tab_Index
            end
        end
    end

    Refresh_Active_Layout()
    self:Set_No_Results(not Any_Match)

    if First_Match_Tab and First_Match_Tab ~= self.Active_Tab then
        task.delay(0.18, function()
            if self.Search_Generation ~= My_Generation then return end
            if not self.Search_Input then return end
            if self.Search_Input.Text:lower():gsub('^%s*(.-)%s*$', '%1') ~= Query then return end
            self:Switch_Tab(First_Match_Tab)
        end)
    end
end

function Library:Autosave()
    if self.Loading then return end
    if getgenv and getgenv().Config_Enabled == false then return end
    self.Save_Dirty = true
    if self.Auto_Debounce then return end
    self.Auto_Debounce = true
    task.spawn(function()
        while self.Save_Dirty do
            self.Save_Dirty = false
            task.wait(0.4)
            if self.Save_Dirty then continue end
            if getgenv and getgenv().Config_Enabled == false then break end
            local Success = Save_Config(self.Active_Config_Name, self.Flags)
            if Success then
                self:Status('Saved: ' .. self.Active_Config_Name, Theme.Success, 1.2)
            else
                self:Status('Save failed', Theme.Error, 2)
            end
        end
        self.Auto_Debounce = false
    end)
end

function Library:Apply_Flag(Flag, Value, Silent)
    local Control = self.Control_Objects[Flag]
    if not Control then return end
    pcall(Control.Apply, Value, Silent)
end

function Library.New()
    local self = setmetatable({}, Library)

    self:clear()
    self.Saved_Config = {}
    self.Active_Config_Name = Sanitize_File_Name((getgenv and getgenv().Config_Name) or 'Default')
    Theme_Bindings = {}
    Font_Bindings = {}
    Theme_Refresh_Callbacks = {}
    Current_Instance = self

    local Config_Was_Loaded = false
    if not (getgenv and getgenv().Config_Enabled == false) then
        self.Loading = true
        local Loaded = Load_Config(self.Active_Config_Name)
        self.Saved_Config = Loaded or {}
        self.Loading = false
        if Loaded and next(Loaded) ~= nil then
            Config_Was_Loaded = true
        end
    end

    local Keybind = self.Interface_Keybind or Enum.KeyCode.N
    local Title = (getgenv and getgenv().Product_Name) or 'Ancapri'
    local Version = (getgenv and getgenv().Product_Version) or ''

    local Existing = CoreGui:FindFirstChild('Ancapri')
    if Existing then Existing:Destroy() end

    local Screen_Gui = Create_Instance('ScreenGui', {
        Name = 'Ancapri',
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, CoreGui)

    local Sounds = {
        ['Tab'] = 6895079853,
        ['Minimize'] = 104184340183231,
    }

    self.Gui = Screen_Gui
    self.Custom_Size = Vector2.new(700, 450)
    local Volume = self.Clicks_Volume_Enabled or 1

    local Main_Panel = Create_Instance('CanvasGroup', {
        Name = 'Panel',
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(700, 450),
        BackgroundColor3 = Theme_Ref('Panel'),
        BorderSizePixel = 0,
        GroupTransparency = 1,
        ZIndex = 10,
    }, Screen_Gui)

    Create_Corner(Main_Panel, 14)
    self.Panel = Main_Panel

    local Interface_Scale = Create_Instance('UIScale', {
        Scale = 1,
    }, Main_Panel)

    self.Interface_Scale = Interface_Scale

    local function Update_Interface_Scale(Instant)
        if not Camera then return end
        local Viewport_Y = Camera.ViewportSize.Y
        local Raw_Scale = math.clamp(Viewport_Y / 1080, 1, 1.4)
        local Target_Scale = math.floor(Raw_Scale * 20 + 0.5) / 20

        if Instant then
            Interface_Scale.Scale = Target_Scale
        else
            Create_Tween(Interface_Scale, 0.3, {Scale = Target_Scale}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end
    end

    Update_Interface_Scale(true)

    Connection.Viewport_Scale = Workspace:GetPropertyChangedSignal('CurrentCamera'):Connect(function()
        Camera = Workspace.CurrentCamera
        Update_Interface_Scale(true)
        if Camera then
            Connection.Viewport_Resize = Camera:GetPropertyChangedSignal('ViewportSize'):Connect(function()
                Update_Interface_Scale(false)
            end)
        end
    end)

    if Camera then
        Connection.Viewport_Resize = Camera:GetPropertyChangedSignal('ViewportSize'):Connect(function()
            Update_Interface_Scale(false)
        end)
    end

    local function Safe_Clamp_X(Abs_X, Half_W, Viewport_X)
        local Min_X, Max_X = Half_W, Viewport_X - Half_W
        if Min_X > Max_X then
            return Viewport_X / 2
        end
        return math.clamp(Abs_X, Min_X, Max_X)
    end

    local function Safe_Clamp_Y(Abs_Y, Half_H, Viewport_Y)
        local Min_Y, Max_Y = Half_H, Viewport_Y - Half_H
        if Min_Y > Max_Y then
            return Viewport_Y / 2
        end
        return math.clamp(Abs_Y, Min_Y, Max_Y)
    end

    local Drag_Goal_Position = nil
    local Is_Being_Dragged = false

    local function Begin_Drag_Session()
        Is_Being_Dragged = true
    end

    local function End_Drag_Session()
        Is_Being_Dragged = false
    end

    local function Update_Drag_Target(Start_Position, Drag_Start_Input, Current_Position)
        local Delta = Current_Position - Drag_Start_Input
        local Viewport = Screen_Gui.AbsoluteSize
        local Abs_X = Start_Position.X.Scale * Viewport.X + Start_Position.X.Offset + Delta.X
        local Abs_Y = Start_Position.Y.Scale * Viewport.Y + Start_Position.Y.Offset + Delta.Y
        local Half_W = Main_Panel.AbsoluteSize.X / 2
        local Half_H = Main_Panel.AbsoluteSize.Y / 2
        local Freedom = self.Freedom_Enabled == true
        if not Freedom then
            Abs_X = Safe_Clamp_X(Abs_X, Half_W, Viewport.X)
            Abs_Y = Safe_Clamp_Y(Abs_Y, Half_H, Viewport.Y)
        end
        Drag_Goal_Position = UDim2.new(0, Abs_X, 0, Abs_Y)
    end

    Connection.Panel_Drag_Follow = RunService.Heartbeat:Connect(function(Delta_Time)
        if not Drag_Goal_Position then return end
        local Smoothness = tonumber(self.Interface_Drag_Smoothness_Enabled)
        if not Smoothness or Smoothness <= 0 then Smoothness = 1 end
        local Alpha = math.clamp(1 - math.exp(-(22 / Smoothness) * Delta_Time), 0, 1)
        Main_Panel.Position = Main_Panel.Position:Lerp(Drag_Goal_Position, Alpha)
        if not Is_Being_Dragged then
            local Current_X, Goal_X = Main_Panel.Position.X.Offset, Drag_Goal_Position.X.Offset
            local Current_Y, Goal_Y = Main_Panel.Position.Y.Offset, Drag_Goal_Position.Y.Offset
            if math.abs(Current_X - Goal_X) < 0.5 and math.abs(Current_Y - Goal_Y) < 0.5 then
                Main_Panel.Position = Drag_Goal_Position
                Drag_Goal_Position = nil
            end
        end
    end)

    local Title_Bar = Create_Instance('Frame', {
        Name = 'Top',
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundTransparency = 1,
        ZIndex = 11,
    }, Main_Panel)

    do
        local Drag_Start_Input, Start_Position = nil, nil
        local Drag_Handle = Create_Instance('TextButton', {
            Name = 'Drag',
            Size = UDim2.new(1, 0, 0, 46),
            BackgroundTransparency = 1,
            Text = '',
            ZIndex = 50,
            AutoButtonColor = false,
        }, Title_Bar)

        Drag_Handle.InputBegan:Connect(function(Input)
            if self.Interface_Drag_Enabled == false then return end
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Drag_Start_Input, Start_Position = Input.Position, Main_Panel.Position
                Begin_Drag_Session()
            end
        end)

        Drag_Handle.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                End_Drag_Session()
            end
        end)

        Connection.Title_Drag_Input = UserInputService.InputChanged:Connect(function(Input)
            if not Is_Being_Dragged or not Drag_Start_Input then return end
            if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            Update_Drag_Target(Start_Position, Drag_Start_Input, Input.Position)
        end)
    end

    task.spawn(function()
        local Was_Free = self.Freedom_Enabled == true
        local Was_Drag_Enabled = self.Interface_Drag_Enabled ~= false
        local Last_Auto_Viewport = Screen_Gui.AbsoluteSize
        while Main_Panel and Main_Panel.Parent do
            local Freedom = self.Freedom_Enabled == true
            local Drag_Enabled = self.Interface_Drag_Enabled ~= false

            local Viewport_Now = Screen_Gui.AbsoluteSize

            if self.Auto_Resize_Enabled and Viewport_Now ~= Last_Auto_Viewport then
                Last_Auto_Viewport = Viewport_Now
                self:Auto_Resize(false, true)
            end

            local Panel_Size_Now = Main_Panel.AbsoluteSize
            local Is_Oversized = Panel_Size_Now.X > Viewport_Now.X or Panel_Size_Now.Y > Viewport_Now.Y
            local Freedom_Turned_Off = Was_Free and not Freedom
            local Drag_Turned_Off = Was_Drag_Enabled and not Drag_Enabled

            local Should_Fit = Is_Oversized or Freedom_Turned_Off

            if Drag_Turned_Off and not Should_Fit then
                Create_Tween(Main_Panel, 0.4, {
                    Position = UDim2.fromScale(0.5, 0.5),
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            end

            if Should_Fit then
                local Viewport = Viewport_Now
                local Current_Size = Panel_Size_Now

                local New_Width = math.min(Current_Size.X, Viewport.X)
                local New_Height = math.min(Current_Size.Y, Viewport.Y)

                if New_Width ~= Current_Size.X or New_Height ~= Current_Size.Y then
                    Create_Tween(Main_Panel, 0.35, {
                        Size = UDim2.fromOffset(New_Width, New_Height),
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

                    if not self.Minimized then
                        self.Custom_Size = Vector2.new(New_Width, New_Height)
                    end
                end

                local Half_W = New_Width / 2
                local Half_H = New_Height / 2
                local Current_Pos = Main_Panel.Position
                local Abs_X = Current_Pos.X.Scale * Viewport.X + Current_Pos.X.Offset
                local Abs_Y = Current_Pos.Y.Scale * Viewport.Y + Current_Pos.Y.Offset
                Abs_X = Safe_Clamp_X(Abs_X, Half_W, Viewport.X)
                Abs_Y = Safe_Clamp_Y(Abs_Y, Half_H, Viewport.Y)
                Create_Tween(Main_Panel, 0.35, {Position = UDim2.new(0, Abs_X, 0, Abs_Y)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            end

            Was_Free = Freedom
            Was_Drag_Enabled = Drag_Enabled
            task.wait(0.1)
        end
    end)

    task.spawn(function()
        local Was_Dynamic = self.Dynamic_Tabs_Enabled ~= false
        local Toggle_Reaction_Speed = 0.12
        while Main_Panel and Main_Panel.Parent do
            local Dynamic_Tabs_Enabled = self.Dynamic_Tabs_Enabled ~= false
            if Dynamic_Tabs_Enabled ~= Was_Dynamic then
                for Tab_Index, _ in ipairs(self.Tab_Buttons) do
                    local Icon_Object = self.Tab_Icons[Tab_Index]
                    local Is_Active = (Tab_Index == self.Active_Tab)
                    if Icon_Object and not Is_Active then
                        Icon_Object.Rotation = 0
                        Icon_Object.Position = UDim2.fromOffset(0, 0)
                        if Dynamic_Tabs_Enabled then
                            Create_Tween(Icon_Object, Toggle_Reaction_Speed, {
                                Size = UDim2.fromOffset(0, 16),
                                ImageTransparency = 1,
                            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                        else
                            Create_Tween(Icon_Object, Toggle_Reaction_Speed, {
                                Size = UDim2.fromOffset(16, 16),
                                ImageTransparency = 0,
                            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                        end
                    end
                end
            end
            Was_Dynamic = Dynamic_Tabs_Enabled
            task.wait(0.1)
        end
    end)

    Create_Instance('Frame', {
        Name = 'Accent',
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 3),
        BackgroundColor3 = Theme_Ref('Accent'),
        BorderSizePixel = 0,
        ZIndex = 50,
    }, Title_Bar)

    local Warper = Create_Instance('Frame', {
        Name = 'Warper',
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 5, 0.5, 0),
        Size = UDim2.fromOffset(50, 40),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 20,
    }, Title_Bar)

    local Animated = Create_Instance('ImageLabel', {
        Name = 'Animated',
        Size = UDim2.new(3, 0, 3, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = 'rbxassetid://133009150415671',
        ImageTransparency = 1,
        ZIndex = 21,
    }, Warper)

    do
        local Warper_Framerate = self.Animation_Frame_Rate or 12
        local Current_Frame = 1
        local Total_Frames = 8
        local Row_Count = 3
        local Column_Count = 3
        local Last_Time = tick()
        local Animation_Connection
        Animation_Connection = RunService.Heartbeat:Connect(function()
            if not Animated or not Animated.Parent then
                Animation_Connection:Disconnect()
                return
            end
            local Real_Time = tick()
            if Real_Time - Last_Time >= 1 / Warper_Framerate then
                Current_Frame = (Current_Frame % Total_Frames) + 1
                local Current_Column = ((Current_Frame - 1) % Column_Count) + 1
                local Current_Row = math.floor((Current_Frame - 1) / Column_Count) + 1
                Animated.Position = UDim2.new(-(Current_Column - 1), 0, -(Current_Row - 1), 0)
                Last_Time = Real_Time
            end
        end)
        Create_Tween(Animated, 0.8, {ImageTransparency = 0})
    end

    local Title_Label = Create_Instance('TextLabel', {
        Name = 'Name',
        Position = UDim2.fromOffset(52, 0),
        Size = UDim2.new(0, 300, 1, 0),
        BackgroundTransparency = 1,
        FontFace = Font_Ref(Enum.FontWeight.SemiBold),
        TextSize = 20,
        Text = Title,
        TextColor3 = Theme_Ref('Accent'),
        TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true,
        ZIndex = 12,
    }, Title_Bar)

    self.Title_Label = Title_Label

    Create_Instance('TextLabel', {
        Name = 'Version',
        Position = UDim2.fromOffset(120, 0),
        Size = UDim2.new(0, 80, 1, 0),
        BackgroundTransparency = 1,
        FontFace = Font_Ref(Enum.FontWeight.SemiBold),
        TextSize = 13,
        Text = Version,
        TextColor3 = Theme_Ref('Dim'),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 12,
    }, Title_Bar)

    if Device['Mobile'] then
        local Close_Button = Create_Instance('ImageButton', {
            Name = 'Close',
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(34, 28),
            BackgroundColor3 = Theme_Ref('Panel_2'),
            BorderSizePixel = 0,
            Image = '',
            ZIndex = 60,
            AutoButtonColor = false,
        }, Title_Bar)

        Create_Stroke(Close_Button, 'Border', 1, 0.8)
        Create_Corner(Close_Button, 6)

        local Close_Icon = Create_Instance('ImageLabel', {
            Name = 'Icon',
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(16, 16),
            BackgroundTransparency = 1,
            Image = 'rbxassetid://7733771982',
            ImageColor3 = Theme_Ref('Accent'),
            ZIndex = 61,
        }, Close_Button)

        self.Close_Icon = Close_Icon

        Close_Button.MouseButton1Click:Connect(function()
            self:Hide()
        end)
    end

    local Minimize_Button = Create_Instance('TextButton', {
        Name = 'Minimize',
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, Device['Mobile'] and -56 or -14, 0.5, 0),
        Size = UDim2.fromOffset(72, 26),
        BackgroundColor3 = Theme_Ref('Panel_2'),
        BorderSizePixel = 0,
        FontFace = Font_Ref(Enum.FontWeight.SemiBold),
        TextSize = 12,
        Text = '▼  Min',
        TextColor3 = Theme_Ref('Muted'),
        ZIndex = 60,
        AutoButtonColor = false,
    }, Title_Bar)

    Create_Corner(Minimize_Button, 6)
    Create_Stroke(Minimize_Button, 'Border', 1, 0.4)

    self.Minimize_Button = Minimize_Button
    self.Minimize_Sound = Create_Sound(Minimize_Button, Sounds['Minimize'], Volume)

    Minimize_Button.MouseButton1Click:Connect(function()
        self:Toggle_Minimize()
    end)

    Minimize_Button.MouseEnter:Connect(function()
        Create_Tween(Minimize_Button, 0.12, {BackgroundColor3 = Theme.Accent_Muted, TextColor3 = Theme.Accent})
    end)

    Minimize_Button.MouseLeave:Connect(function()
        Create_Tween(Minimize_Button, 0.12, {BackgroundColor3 = Theme.Panel_2, TextColor3 = Theme.Muted})
    end)

    local Panic_Button = Create_Instance('ImageButton', {
        Name = 'Panic',
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, Device['Mobile'] and -134 or -92, 0.5, 0),
        Size = UDim2.fromOffset(30, 26),
        BackgroundColor3 = Theme_Ref('Panel_2'),
        BorderSizePixel = 0,
        Image = '',
        ZIndex = 60,
        AutoButtonColor = false,
    }, Title_Bar)

    Create_Corner(Panic_Button, 6)
    Create_Stroke(Panic_Button, 'Border', 1, 0.8)

    local Panic_Icon = Create_Instance('ImageLabel', {
        Name = 'Icon',
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        Image = 'rbxassetid://7734052653',
        ImageColor3 = Theme_Ref('Dim'),
        ZIndex = 61,
    }, Panic_Button)

    self.Panic_Icon = Panic_Icon

    Panic_Button.MouseEnter:Connect(function()
        Create_Tween(Panic_Icon, 0.3, {ImageColor3 = Theme.Accent})
    end)

    Panic_Button.MouseLeave:Connect(function()
        Create_Tween(Panic_Icon, 0.3, {ImageColor3 = Theme.Dim})
    end)

    Panic_Button.MouseButton1Click:Connect(function()
        self:Set_Lock(true)
        task.wait(1)
        self:Destroy_Interface()
    end)

    local Uptime_Position = UDim2.new(1, Device['Mobile'] and -170 or -128, 0.5, 0)

    local Uptime_Container = Create_Instance('Frame', {
        Name = 'Uptime',
        AnchorPoint = Vector2.new(1, 0.5),
        Position = Uptime_Position,
        Size = UDim2.fromOffset(0, 20),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        ZIndex = 60,
    }, Title_Bar)

    Create_Instance('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
    }, Uptime_Container)

    local function Make_Unit_Slot(Order)
        local Slot = Create_Instance('Frame', {
            Size = UDim2.fromOffset(0, 20),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            LayoutOrder = Order,
            Visible = false,
            ZIndex = 60,
        }, Uptime_Container)

        local Label = Create_Instance('TextLabel', {
            Size = UDim2.fromOffset(0, 20),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Font = Enum.Font.Code,
            TextSize = 12,
            Text = '',
            TextTransparency = 1,
            TextColor3 = Theme_Ref('Dim'),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 61,
        }, Slot)
        return Slot, Label
    end

    local Hours_Slot, Hours_Label = Make_Unit_Slot(1)
    local Minutes_Slot, Minutes_Label = Make_Unit_Slot(2)
    local Seconds_Slot, Seconds_Label = Make_Unit_Slot(3)

    self.Uptime_Container = Uptime_Container
    self.Start_Time = os.clock()

    local function Fade_In_Slot(Slot)
        local Label = Slot:FindFirstChildOfClass('TextLabel')
        if not Label then return end

        Label.TextTransparency = 1
        Create_Tween(Label, 0.35, {
            TextTransparency = 0,
        }, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    end

    local function Animate_Segment(Label, New_Text)
        Create_Tween(Label, 0.12, {
            TextTransparency = 1,
        }, Enum.EasingStyle.Sine, Enum.EasingDirection.In)

        task.delay(0.12, function()
            if not Label or not Label.Parent then return end

            Label.Text = New_Text

            Create_Tween(Label, 0.25, {
                TextTransparency = 0,
            }, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        end)
    end

    local Last_Hours, Last_Minutes, Last_Seconds = nil, nil, nil

    task.spawn(function()
        while Uptime_Container and Uptime_Container.Parent do
            local Elapsed = math.floor(os.clock() - self.Start_Time)
            local Hours = math.floor(Elapsed / 3600)
            local Minutes = math.floor((Elapsed % 3600) / 60)
            local Seconds = Elapsed % 60

            if Seconds ~= Last_Seconds then
                Last_Seconds = Seconds
                local Text = Seconds .. 's'

                if Seconds_Label.Text == '' then
                    Seconds_Label.Text = Text
                    Seconds_Slot.Visible = true
                    Fade_In_Slot(Seconds_Slot)
                else
                    Animate_Segment(Seconds_Label, Text)
                end
            end

            if Minutes ~= Last_Minutes and (Minutes > 0 or Last_Minutes ~= nil) then
                Last_Minutes = Minutes
                local Text = Minutes .. 'm'

                if Minutes_Label.Text == '' then
                    Minutes_Label.Text = Text
                    Minutes_Slot.Visible = true
                    Fade_In_Slot(Minutes_Slot)
                else
                    Animate_Segment(Minutes_Label, Text)
                end
            end

            if Hours ~= Last_Hours and (Hours > 0 or Last_Hours ~= nil) then
                Last_Hours = Hours
                local Text = Hours .. 'h'

                if Hours_Label.Text == '' then
                    Hours_Label.Text = Text
                    Hours_Slot.Visible = true
                    Fade_In_Slot(Hours_Slot)
                else
                    Animate_Segment(Hours_Label, Text)
                end
            end
            task.wait(0.2)
        end
    end)

    local Tab_Bar = Create_Instance('ScrollingFrame', {
        Name = 'Tabs',
        Position = UDim2.new(0, 0, 0, 46),
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollingDirection = Enum.ScrollingDirection.X,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        ZIndex = 11,
    }, Main_Panel)

    Create_Instance('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
    }, Tab_Bar)

    Create_Instance('UIPadding', {
        PaddingLeft = UDim.new(0, 16),
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 8),
    }, Tab_Bar)

    self.Tab_Bar = Tab_Bar
    self.Tab_Sound = Create_Sound(Tab_Bar, Sounds['Tab'], Volume)

    local Search_Bar = Create_Instance('Frame', {
        Name = 'Search Bar',
        Position = UDim2.new(0, 0, 0, 84),
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 1,
        ZIndex = 11,
    }, Main_Panel)

    local Search_Box = Create_Instance('Frame', {
        Name = 'Box',
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -28, 0, 26),
        BackgroundColor3 = Theme_Ref('Panel_2'),
        BorderSizePixel = 0,
        ZIndex = 12,
    }, Search_Bar)

    Create_Corner(Search_Box, 6)

    local Search_Stroke = Create_Stroke(Search_Box, 'Border', 1, 0.5)

    local Search_Icon = Create_Instance('ImageLabel', {
        Name = 'Icon',
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.new(0.00999999978, 0, 0.100000001, 0),
        BackgroundTransparency = 1,
        Image = 'rbxassetid://17441620727',
        ImageColor3 = Theme_Ref('Border'),
        LayoutOrder = 1,
        ZIndex = 13,
    }, Search_Box)

    local Search_Input = Create_Instance('TextBox', {
        Name = 'Input',
        Position = UDim2.fromOffset(30, 0),
        Size = UDim2.new(1, -64, 1, 0),
        BackgroundTransparency = 1,
        FontFace = Font_Ref(Enum.FontWeight.SemiBold),
        TextSize = 12,
        Text = '',
        PlaceholderText = 'Search features...',
        PlaceholderColor3 = Theme_Ref('Dim'),
        TextColor3 = Theme_Ref('Text'),
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ClipsDescendants = true,
        ZIndex = 13,
    }, Search_Box)

    self.Search_Input = Search_Input

    local Clear_Button = Create_Instance('TextButton', {
        Name = 'Clear',
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(18, 18),
        BackgroundTransparency = 1,
        Font = Enum.Font.Code,
        TextSize = 13,
        Text = 'X',
        TextColor3 = Theme_Ref('Dim'),
        Visible = false,
        ZIndex = 13,
        AutoButtonColor = false,
    }, Search_Box)

    Search_Input.Focused:Connect(function()
        Create_Tween(Search_Stroke, 0.3, {Color = Theme.Border, Transparency = 0.3})
        Create_Tween(Search_Icon, 0.3, {ImageColor3 = Theme.Accent})
    end)

    Search_Input.FocusLost:Connect(function()
        Create_Tween(Search_Stroke, 0.3, {Color = Theme.Border, Transparency = 0.3})
        Create_Tween(Search_Icon, 0.3, {ImageColor3 = Theme.Border})
    end)

    Search_Input:GetPropertyChangedSignal('Text'):Connect(function()
        Clear_Button.Visible = Search_Input.Text ~= ''
        self:Search(Search_Input.Text)
    end)

    Clear_Button.MouseButton1Click:Connect(function()
        Search_Input.Text = ''
    end)

    local Body_Scroller = Create_Instance('ScrollingFrame', {
        Name = 'Container',
        Position = UDim2.new(0, 0, 0, 119),
        Size = UDim2.new(1, 0, 1, -157),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme_Ref('Accent'),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        ZIndex = 11,
    }, Main_Panel)

    self.Body = Body_Scroller

    local No_Results = Create_Instance('Frame', {
        Name = 'No Results',
        Position = UDim2.new(0, 0, 0, 119),
        Size = UDim2.new(1, 0, 1, -157),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 30,
    }, Main_Panel)

    local No_Results_Image = Create_Instance('ImageLabel', {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 12),
        Size = UDim2.fromOffset(42, 42),
        BackgroundTransparency = 1,
        Image = 'rbxassetid://7733911621',
        ImageColor3 = Theme_Ref('Accent'),
        ImageTransparency = 1,
        ZIndex = 31,
    }, No_Results)

    local No_Results_Label = Create_Instance('TextLabel', {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 38),
        Size = UDim2.fromOffset(220, 20),
        BackgroundTransparency = 1,
        FontFace = Font_Ref(Enum.FontWeight.SemiBold),
        TextSize = 13,
        Text = 'Nothing found.',
        TextColor3 = Theme_Ref('Dim'),
        TextTransparency = 1,
        ZIndex = 31,
    }, No_Results)

    self.No_Results = No_Results
    self.No_Results_Image = No_Results_Image
    self.No_Results_Label = No_Results_Label

    local Interface_Icons = {
        ['Locked'] = 'rbxassetid://121830702067948',
        ['Unlocked'] = 'rbxassetid://102151842256737',
    }

    self.Interface_Icons = Interface_Icons
    self.Lock_Overlay = nil
    self.Lock_Glyph = nil
    self.Lock_Caption = nil
    self.Locked = false
    self.Interface_Mode = 'Unlocked'

    local Footer = Create_Instance('Frame', {
        Name = 'Status',
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Theme_Ref('Panel'),
        BorderSizePixel = 0,
        ZIndex = 12,
    }, Main_Panel)

    Create_Instance('Frame', {
        Name = 'Divider',
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Theme_Ref('Border'),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 13,
    }, Footer)

    self.Footer = Footer

    do
        local Footer_Drag_Start, Footer_Start_Position = nil, nil

        local Footer_Drag = Create_Instance('TextButton', {
            Name = 'Drag',
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = '',
            ZIndex = 13,
            AutoButtonColor = false,
        }, Footer)

        Footer_Drag.InputBegan:Connect(function(Input)
            if self.Interface_Drag_Enabled == false then return end
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Footer_Drag_Start = Input.Position
                Footer_Start_Position = Main_Panel.Position
                Begin_Drag_Session()
            end
        end)

        Footer_Drag.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                End_Drag_Session()
            end
        end)

        Connection.Footer_Drag_Input = UserInputService.InputChanged:Connect(function(Input)
            if not Is_Being_Dragged or not Footer_Drag_Start then return end
            if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then return end
            Update_Drag_Target(Footer_Start_Position, Footer_Drag_Start, Input.Position)
        end)
    end

    local Resize_Button = Create_Instance('ImageButton', {
        Name = 'Resize',
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -4, 1, -4),
        Size = UDim2.fromOffset(32, 32),
        BackgroundTransparency = 1,
        Image = 'rbxassetid://10734961133',
        ImageColor3 = Theme_Ref('Dim'),
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 60,
    }, Main_Panel)

    Create_Instance('UIPadding', {
        PaddingLeft = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 8),
    }, Resize_Button)

    Resize_Button.MouseEnter:Connect(function()
        Create_Tween(Resize_Button, 0.12, {ImageColor3 = Theme.Accent})
    end)

    Resize_Button.MouseLeave:Connect(function()
        if not self.Resizing then
            Create_Tween(Resize_Button, 0.12, {ImageColor3 = Theme.Dim})
        end
    end)

    self.Resizing = false
    self.Resize_Start = nil
    self.Size_Start = nil

    if Device['Mobile'] then
        local Resize_Hitbox = Create_Instance('Frame', {
            Name = 'Hitbox',
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, 0, 1, 0),
            Size = UDim2.fromOffset(54, 54),
            BackgroundTransparency = 1,
            ZIndex = 59,
        }, Main_Panel)

        Resize_Hitbox.InputBegan:Connect(function(Input)
            if Input.UserInputType ~= Enum.UserInputType.Touch then return end
            self.Resizing = true
            self.Resize_Start = Vector2.new(Input.Position.X, Input.Position.Y)
            self.Size_Start = Main_Panel.Size
        end)

        Resize_Hitbox.InputChanged:Connect(function(Input)
            if not self.Resizing or Input.UserInputType ~= Enum.UserInputType.Touch then return end
            local Current_Pos = Vector2.new(Input.Position.X, Input.Position.Y)
            local Delta = Current_Pos - self.Resize_Start
            self:Apply_Resize(self.Size_Start.X.Offset + Delta.X, self.Size_Start.Y.Offset + Delta.Y, true)
        end)

        Resize_Hitbox.InputEnded:Connect(function(Input)
            if Input.UserInputType ~= Enum.UserInputType.Touch then return end
            self.Resizing = false
            Create_Tween(Resize_Button, 0.12, {ImageColor3 = Theme.Dim})
        end)
    end

    Resize_Button.MouseButton1Down:Connect(function()
        if Device['Mobile'] then return end
        self.Resizing = true
        self.Resize_Start = UserInputService:GetMouseLocation()
        self.Size_Start = Main_Panel.Size
    end)

    Resize_Button.InputBegan:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.Touch then return end
        self.Resizing = true
        self.Resize_Start = Vector2.new(Input.Position.X, Input.Position.Y)
        self.Size_Start = Main_Panel.Size
    end)

    Resize_Button.InputChanged:Connect(function(Input)
        if not self.Resizing or Input.UserInputType ~= Enum.UserInputType.Touch then return end
        local Current_Pos = Vector2.new(Input.Position.X, Input.Position.Y)
        local Delta = Current_Pos - self.Resize_Start
        self:Apply_Resize(self.Size_Start.X.Offset + Delta.X, self.Size_Start.Y.Offset + Delta.Y, true)
    end)

    Resize_Button.InputEnded:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.Touch then return end
        self.Resizing = false
        Create_Tween(Resize_Button, 0.12, {ImageColor3 = Theme.Dim})
    end)

    Connection.Resize_Mouse_End = UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        self.Resizing = false
        Create_Tween(Resize_Button, 0.12, {ImageColor3 = Theme.Dim})
    end)

    Connection.Resize_Mouse_Drag = UserInputService.InputChanged:Connect(function(Input)
        if not self.Resizing or Input.UserInputType ~= Enum.UserInputType.MouseMovement or Device['Mobile'] then return end
        local Delta = UserInputService:GetMouseLocation() - self.Resize_Start
        self:Apply_Resize(self.Size_Start.X.Offset + Delta.X, self.Size_Start.Y.Offset + Delta.Y, false)
    end)

    local Status_Dot = Create_Instance('Frame', {
        Name = 'Dot',
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 16, 0.5, 0),
        Size = UDim2.fromOffset(6, 6),
        BackgroundColor3 = Theme_Ref('Accent'),
        BorderSizePixel = 0,
        ZIndex = 14,
    }, Footer)

    Create_Corner(Status_Dot, 3)
    self.Status_Dot = Status_Dot

    task.spawn(function()
        if not self.Status_Dot then return end
        while self.Status_Dot and self.Status_Dot.Parent do
            local In = TweenService:Create(self.Status_Dot, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0.35,
            })
            local Out = TweenService:Create(self.Status_Dot, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0,
            })
            In:Play()
            In.Completed:Wait()
            Out:Play()
            Out.Completed:Wait()
        end
    end)

    local Status_Label = Create_Instance('TextLabel', {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 28, 0.5, 0),
        Size = UDim2.fromOffset(300, 20),
        BackgroundTransparency = 1,
        Font = Enum.Font.Code,
        TextSize = 12,
        Text = 'Active session running',
        TextColor3 = Theme_Ref('Muted'),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14,
    }, Footer)

    self.Status_Label = Status_Label

    local Clock_Label = Create_Instance('TextLabel', {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -34, 0.5, 0),
        Size = UDim2.fromOffset(220, 20),
        BackgroundTransparency = 1,
        Font = Enum.Font.Code,
        TextSize = 11,
        Text = '',
        TextColor3 = Theme_Ref('Dim'),
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 14,
    }, Footer)

    if Device['Mobile'] then
        local Float_Button = Create_Instance('ImageButton', {
            Name = 'Mobile',
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -24),
            Size = UDim2.fromOffset(70, 35),
            BackgroundColor3 = Theme_Ref('Panel_2'),
            BorderSizePixel = 0,
            Image = 'rbxassetid://7743875962',
            ImageColor3 = Theme_Ref('Accent'),
            ImageTransparency = 1,
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 100,
            Visible = false,
            BackgroundTransparency = 1,
            AutoButtonColor = false,
        }, Screen_Gui)

        Create_Corner(Float_Button, 8)
        self.Float_Button = Float_Button

        local Dragging, Drag_Start, Start_Position, Did_Drag = false, nil, nil, false
        Float_Button.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging, Did_Drag, Drag_Start, Start_Position = true, false, Input.Position, Float_Button.Position
            end
        end)

        Float_Button.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = false
            end
        end)

        Connection.Float_Drag_Input = UserInputService.InputChanged:Connect(function(Input)
            if not Dragging then return end
            if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            local Delta = Input.Position - Drag_Start
            if Delta.Magnitude > 4 then Did_Drag = true end
            if not Did_Drag then return end
            local Viewport = Screen_Gui.AbsoluteSize
            local Abs_X = Start_Position.X.Scale * Viewport.X + Start_Position.X.Offset + Delta.X
            local Abs_Y = Start_Position.Y.Scale * Viewport.Y + Start_Position.Y.Offset + Delta.Y
            Abs_X = math.clamp(Abs_X, Float_Button.AbsoluteSize.X / 2, Viewport.X - Float_Button.AbsoluteSize.X / 2)
            Abs_Y = math.clamp(Abs_Y, Float_Button.AbsoluteSize.Y / 2, Viewport.Y - Float_Button.AbsoluteSize.Y / 2)
            Create_Tween(Float_Button, 0.05, {Position = UDim2.new(0, Abs_X, 0, Abs_Y)}, Enum.EasingStyle.Linear)
        end)
        Float_Button.MouseButton1Click:Connect(function()
            if Did_Drag then Did_Drag = false return end
            if not self.Visible then self:Show() end
        end)
    end

    Connection.Global_Input = UserInputService.InputBegan:Connect(function(Input, Processed)
        if self.Capturing and Input.UserInputType == Enum.UserInputType.Keyboard then
            self.Capturing(Input.KeyCode)
            return
        end
        if Processed then return end
        local Live_Keybind = self.Interface_Keybind or Keybind
        if Input.KeyCode == Live_Keybind then self:Toggle() end
    end)

    task.spawn(function()
        while Main_Panel and Main_Panel.Parent do
            local Time = os.date('*t')
            local Hour = Time.hour % 12
            if Hour == 0 then Hour = 12 end
            local Live_Keybind = self.Interface_Keybind or Keybind
            Clock_Label.Text = string.format('[%s] toggle  ·  %d:%02d %s',
                tostring(Live_Keybind):gsub('Enum.KeyCode.', ''), Hour, Time.min, Time.hour >= 12 and 'PM' or 'AM')
            task.wait(1)
        end
    end)

    task.spawn(function()
        local Dot = true
        while Title_Label and Title_Label.Parent do
            Title_Label.Text = Title .. (Dot and '.' or '')
            Dot = not Dot
            task.wait(0.55)
        end
    end)

    self:Init_Notifications()
    Register_Theme_Refresh(self.Tab_Bar, function() self:Refresh_Tab_Colors() end)

    Main_Panel.GroupTransparency = 1
    task.wait(0.05)
    self:Show()

    if Config_Was_Loaded then
        task.delay(0.6, function()
            self:Status('Config loaded: ' .. self.Active_Config_Name, Theme.Success, 2)
        end)
    end
    return self
end

function Library:Switch_Tab(Index)
    if Index == self.Active_Tab or not self.Tabs[Index] then return end
    if self.Switching then return end
    if self.Open_Dropdown then self.Open_Dropdown() end
    if self.Tab_Sound then
        self.Tab_Sound.Volume = self.Clicks_Volume_Enabled or 0.5
        self.Tab_Sound:Play()
    end

    self.Switching = true
    self.Switch_Generation = (self.Switch_Generation or 0) + 1
    local My_Switch_Generation = self.Switch_Generation

    local Out_Pane = self.Tabs[self.Active_Tab]
    local In_Pane = self.Tabs[Index]

    Out_Pane.Visible = true
    Out_Pane.GroupTransparency = 0
    Out_Pane.Position = UDim2.fromScale(0, 0)

    Create_Tween(Out_Pane, 0.16, {GroupTransparency = 1, Position = UDim2.fromScale(0, -0.03)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    local Previous = self.Active_Tab
    task.delay(0.16, function()
        if self.Switch_Generation ~= My_Switch_Generation then return end
        if self.Tabs[Previous] and Previous ~= self.Active_Tab then
            self.Tabs[Previous].Visible = false
            self.Tabs[Previous].Position = UDim2.fromScale(0, 0)
        end
        In_Pane.Visible = true
        In_Pane.GroupTransparency = 1
        In_Pane.Position = UDim2.fromScale(0, 0.04)
        Create_Tween(In_Pane, 0.26, {GroupTransparency = 0, Position = UDim2.fromScale(0, 0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        task.spawn(function()
            RunService.Heartbeat:Wait()
            In_Pane.AutomaticSize = Enum.AutomaticSize.None
            RunService.Heartbeat:Wait()
            In_Pane.AutomaticSize = Enum.AutomaticSize.Y
        end)
        for _, Descendant in ipairs(In_Pane:GetDescendants()) do
            if Descendant:GetAttribute('IsDivider') then
                Descendant:SetAttribute('Replay', tick())
            end
        end
        task.delay(0.28, function()
            if self.Switch_Generation ~= My_Switch_Generation then return end
            self.Switching = false
        end)
    end)

    self.Active_Tab = Index
    self:Refresh_Tab_Colors()
end

function Library:Refresh_Tab_Colors()
    for Tab_Index, Button in ipairs(self.Tab_Buttons) do
        local Is_Active = (Tab_Index == self.Active_Tab)
        Create_Tween(Button, 0.16, {
            BackgroundColor3 = Is_Active and Theme.Accent_Muted or Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = Is_Active and 0 or 1,
            TextColor3 = Is_Active and Theme.Accent or Theme.Dim,
        })

        local Underline = Button:FindFirstChild('Underline')

        if Underline then
            Create_Tween(Underline, 0.22, {
                BackgroundColor3 = Theme.Accent,
                BackgroundTransparency = Is_Active and 0 or 1,
                Size = Is_Active and UDim2.new(1, -8, 0, 2) or UDim2.new(0, 0, 0, 2),
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end

        local Icon_Object = self.Tab_Icons[Tab_Index]
        local Dynamic_Tabs_Enabled = self.Dynamic_Tabs_Enabled ~= false
        local Dynamic_Tabs_Animation_Speed = self.Dynamic_Tabs_Animation_Speed_Enabled or 0.25
        local Dynamic_Tabs_Animation_Style = self.Dynamic_Tabs_Animations_Type_Enabled or 'Grow'

        if Icon_Object then
            if Dynamic_Tabs_Enabled and Is_Active then
                Icon_Object.Rotation = 0
                if Dynamic_Tabs_Animation_Style == 'Pop' then
                    Icon_Object.Size = UDim2.fromOffset(0, 0)
                    Icon_Object.ImageTransparency = 1
                    Icon_Object.Position = UDim2.fromOffset(0, 0)
                    Create_Tween(Icon_Object, Dynamic_Tabs_Animation_Speed * 0.7, {
                        ImageTransparency = 0,
                        Size = UDim2.fromOffset(18, 18),
                    }, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                    task.delay(Dynamic_Tabs_Animation_Speed * 0.7, function()
                        if Icon_Object and Icon_Object.Parent then
                            Create_Tween(Icon_Object, Dynamic_Tabs_Animation_Speed * 0.4, {
                                Size = UDim2.fromOffset(16, 16),
                            }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                        end
                    end)
                elseif Dynamic_Tabs_Animation_Style == 'Fade' then
                    Icon_Object.Size = UDim2.fromOffset(16, 16)
                    Icon_Object.ImageTransparency = 1
                    Icon_Object.Position = UDim2.fromOffset(-10, 0)
                    Create_Tween(Icon_Object, Dynamic_Tabs_Animation_Speed, {
                        Position = UDim2.fromOffset(0, 0),
                        ImageTransparency = 0,
                    }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                elseif Dynamic_Tabs_Animation_Style == 'Grow' then
                    Icon_Object.Size = UDim2.fromOffset(0, 0)
                    Icon_Object.ImageTransparency = 1
                    Icon_Object.Position = UDim2.fromOffset(0, 0)
                    Create_Tween(Icon_Object, Dynamic_Tabs_Animation_Speed, {
                        Size = UDim2.fromOffset(16, 16),
                        ImageTransparency = 0,
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                elseif Dynamic_Tabs_Animation_Style == 'Zoom' then
                    Icon_Object.Size = UDim2.fromOffset(26, 26)
                    Icon_Object.ImageTransparency = 1
                    Icon_Object.Position = UDim2.fromOffset(0, 0)
                    Create_Tween(Icon_Object, Dynamic_Tabs_Animation_Speed, {
                        Size = UDim2.fromOffset(16, 16),
                        ImageTransparency = 0,
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                end
            elseif Dynamic_Tabs_Enabled and not Is_Active then
                Icon_Object.Rotation = 0
                Create_Tween(Icon_Object, 0.16, {
                    Size = UDim2.fromOffset(0, 16),
                    ImageTransparency = 1,
                    Position = UDim2.fromOffset(0, 0),
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            else
                Icon_Object.Rotation = 0
                Create_Tween(Icon_Object, 0.16, {
                    Size = UDim2.fromOffset(16, 16),
                    ImageTransparency = 0,
                    Position = UDim2.fromOffset(0, 0),
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            end
        end
    end
end

function Library:Apply_Resize(New_Width, New_Height, Instant)
    if not self.Panel or not self.Gui then return end
    if self.Minimized then return end

    New_Width = math.clamp(New_Width, Panel_Min_Width, Panel_Max_Width)
    New_Height = math.clamp(New_Height, Panel_Min_Height, Panel_Max_Height)

    local Viewport = self.Gui.AbsoluteSize
    New_Width = math.min(New_Width, Viewport.X)
    New_Height = math.min(New_Height, Viewport.Y)

    self.Custom_Size = Vector2.new(New_Width, New_Height)

    if Instant then
        self.Panel.Size = UDim2.fromOffset(New_Width, New_Height)
    else
        Create_Tween(self.Panel, 0.28, {Size = UDim2.fromOffset(New_Width, New_Height)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    end
end

function Library:Auto_Resize(Instant, Silent)
    if not self.Panel or not self.Gui then return end

    local Viewport = self.Gui.AbsoluteSize
    local Target_Width, Target_Height

    if Device['Mobile'] then
        Target_Width = Viewport.X * 0.94
        Target_Height = Viewport.Y * 0.62
    else
        Target_Width = math.clamp(Viewport.X * 0.5, Panel_Min_Width, 760)
        Target_Height = math.clamp(Viewport.Y * 0.56, Panel_Min_Height, 520)
    end

    self:Apply_Resize(Target_Width, Target_Height, Instant)

    if not Silent then
        self:Status('Auto-fit applied', Theme.Accent, 1.4)
    end
end

function Library:Show()
    if self.Tweening then return end
    self.Tweening = true
    if self.Float_Button then self:Fade_Float(false) end
    local Target_Width = self.Custom_Size and self.Custom_Size.X or 700
    local Target_Height = self.Custom_Size and self.Custom_Size.Y or 450
    self.Panel.Visible, self.Panel.GroupTransparency = true, 1
    self.Panel.Size = UDim2.fromOffset(Target_Width, 92)
    self.Body.Visible, self.Footer.Visible = false, false
    self.Minimize_Button.Text, self.Minimized = '▲  Expand', true
    Create_Tween(self.Panel, 0.22, {GroupTransparency = 0})
    task.delay(0.26, function()
        self.Minimized = false
        self.Body.Visible, self.Footer.Visible = true, true
        self.Minimize_Button.Text = '▼  Min'
        Create_Tween(self.Panel, 0.30, {Size = UDim2.fromOffset(Target_Width, Target_Height)})
        task.delay(0.32, function()
            self.Tweening = false
        end)
    end)
    self.Visible = true
end

function Library:Hide()
    if self.Tweening then return end
    self.Tweening, self.Visible = true, false
    self.Body.Visible, self.Footer.Visible = false, false
    self.Minimize_Button.Text, self.Minimized = '▲  Expand', true
    local Target_Width = self.Custom_Size and self.Custom_Size.X or 700
    Create_Tween(self.Panel, 0.22, {Size = UDim2.fromOffset(Target_Width, 92)})
    task.delay(0.26, function()
        Create_Tween(self.Panel, 0.20, {GroupTransparency = 1})
        task.delay(0.22, function()
            self.Panel.Visible = false
            if self.Float_Button then
                self:Fade_Float(true)
            end
            self.Tweening, self.Minimized = false, false
        end)
    end)
end

function Library:Toggle()
    if self.Visible then
        self:Hide()
    else
        self:Show()
    end
end

function Library:Fade_Float(Visible)
    local Float = self.Float_Button
    if not Float then return end
    if Visible then
        Float.Visible = true
        Create_Tween(Float, 0.22, {BackgroundTransparency = 0, ImageTransparency = 0})
    else
        Create_Tween(Float, 0.18, {BackgroundTransparency = 1, ImageTransparency = 1})
        task.delay(0.20, function()
            if Float then Float.Visible = false end
        end)
    end
end

function Library:Set_Lock(State)
    State = State and true or false
    self.Locked = State
    self.Interface_Mode = State and 'Locked' or 'Unlocked'

    self.Lock_Generation = (self.Lock_Generation or 0) + 1
    local My_Generation = self.Lock_Generation

    for _, Button in ipairs(self.Tab_Buttons) do
        Button.Active = not State
    end

    self.Body.ScrollingEnabled = not State

    if self.Search_Input then
        self.Search_Input.TextEditable = not State
    end

    if State then
        if self.Lock_Overlay then
            self.Lock_Overlay:Destroy()
            self.Lock_Overlay = nil
            self.Lock_Glyph = nil
            self.Lock_Caption = nil
        end

        local Lock_Overlay = Create_Instance('Frame', {
            Name = 'Locked',
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Theme_Ref('Panel'),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 70,
        }, self.Panel)

        Create_Corner(Lock_Overlay, 14)

        Create_Instance('UIGradient', {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 10, 14)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 10)),
            }),
            Rotation = 90,
        }, Lock_Overlay)

        local Lock_Glyph = Create_Instance('ImageLabel', {
            Name = 'Glyph',
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.44),
            Size = UDim2.fromOffset(64, 64),
            BackgroundTransparency = 1,
            Image = self.Interface_Icons['Locked'],
            ImageColor3 = Theme_Ref('Accent'),
            ImageTransparency = 1,
            Rotation = -90,
            ZIndex = 72,
        }, Lock_Overlay)

        local Lock_Caption = Create_Instance('TextLabel', {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0.44, 28),
            Size = UDim2.fromOffset(200, 18),
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = 'Interface Locked',
            TextColor3 = Theme_Ref('Accent'),
            TextTransparency = 1,
            ZIndex = 32,
        }, Lock_Overlay)

        Create_Instance('TextButton', {
            Name = 'Shield',
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = '',
            ZIndex = 73,
            AutoButtonColor = false,
        }, Lock_Overlay)

        self.Lock_Overlay = Lock_Overlay
        self.Lock_Glyph = Lock_Glyph
        self.Lock_Caption = Lock_Caption

        Create_Tween(Lock_Overlay, 0.40, {BackgroundTransparency = 0.12}, Enum.EasingStyle.Quint)

        task.delay(0.10, function()
            if self.Lock_Generation ~= My_Generation then return end
            if not Lock_Glyph or not Lock_Glyph.Parent then return end
            Create_Tween(Lock_Glyph, 0.20, {ImageTransparency = 0}, Enum.EasingStyle.Quint)
            Create_Tween(Lock_Glyph, 0.55, {
                Rotation = 0,
                Size = UDim2.fromOffset(52, 52),
            }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            task.delay(0.40, function()
                if self.Lock_Generation ~= My_Generation then return end
                if not Lock_Caption or not Lock_Caption.Parent then return end
                Create_Tween(Lock_Caption, 0.28, {TextTransparency = 0}, Enum.EasingStyle.Quint)
            end)
        end)
    else
        local Glyph = self.Lock_Glyph
        local Caption = self.Lock_Caption
        local Overlay = self.Lock_Overlay

        if not Overlay then
            self:Status('Interface unlocked', Theme.Accent, 1.6)
            return
        end

        self.Lock_Overlay = nil
        self.Lock_Glyph = nil
        self.Lock_Caption = nil

        if Caption then
            Create_Tween(Caption, 0.18, {TextTransparency = 1}, Enum.EasingStyle.Quint)
        end

        task.delay(0.10, function()
            if self.Lock_Generation ~= My_Generation then return end
            if not Glyph or not Glyph.Parent then return end
            Glyph.Image = self.Interface_Icons['Unlocked']
            Glyph.ImageColor3 = Color3.new(1, 1, 1)
            Glyph.Rotation = 0
            Glyph.ImageTransparency = 0
            Glyph.Size = UDim2.fromOffset(52, 52)
            Create_Tween(Glyph, 0.25, {Rotation = 180}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            Create_Tween(Glyph, 0.20, {Size = UDim2.fromOffset(64, 64)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            task.delay(0.25, function()
                if self.Lock_Generation ~= My_Generation then return end
                if not Glyph or not Glyph.Parent then return end
                Create_Tween(Glyph, 0.25, {ImageTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            end)
        end)

        task.delay(0.07, function()
            if self.Lock_Generation ~= My_Generation then return end
            if not Overlay or not Overlay.Parent then return end
            Create_Tween(Overlay, 0.45, {BackgroundTransparency = 1}, Enum.EasingStyle.Sine)
        end)

        task.delay(0.62, function()
            if self.Lock_Generation ~= My_Generation then return end
            if Overlay and Overlay.Parent then
                Overlay:Destroy()
            end
        end)
    end

    self:Status(
        State and 'Interface locked' or 'Interface unlocked',
        State and Theme.Warning or Theme.Accent, 1.6
    )
end

function Library:Toggle_Minimize()
    if self.Tweening then return end
    if self.Minimize_Sound then
        self.Minimize_Sound.Volume = self.Clicks_Volume_Enabled or 0.5
        self.Minimize_Sound:Play()
    end
    self.Minimized = not self.Minimized
    local Target_Width = self.Custom_Size and self.Custom_Size.X or 700
    local Target_Height = self.Minimized and 92 or (self.Custom_Size and self.Custom_Size.Y or 450)
    Create_Tween(self.Panel, 0.28, {Size = UDim2.fromOffset(Target_Width, Target_Height)})
    self.Body.Visible, self.Footer.Visible = not self.Minimized, not self.Minimized
    self.Minimize_Button.Text = self.Minimized and '▲  Expand' or '▼  Min'
end

function Library:Destroy_Interface(Callback)
    if not self:exist() then
        self:Destroy()
        if Callback then pcall(Callback) end
        return
    end

    if self.Tweening then
        task.delay(0.32, function() self:Destroy_Interface(Callback) end)
        return
    end

    self.Tweening = true
    Clear_All_Connections()

    if self.Body then self.Body.Visible = false end
    if self.Footer then self.Footer.Visible = false end
    if self.Minimize_Button then self.Minimize_Button.Text = '▲  Expand' end

    Create_Tween(self.Panel, 0.38, {
        Position = self.Panel.Position - UDim2.fromOffset(0, 18),
        GroupTransparency = 1,
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

    Create_Tween(self.Interface_Scale, 0.38, {
        Scale = self.Interface_Scale.Scale * 0.88,
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

    if self.Float_Button then
        Create_Tween(self.Float_Button, 0.22, {
            BackgroundTransparency = 1,
            ImageTransparency = 1,
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    end

    task.delay(0.40, function()
        self.Tweening = false
        self:Destroy()
        if Callback then pcall(Callback) end
    end)
end

function Library:Create_Tab(Name, Icon)
    local Tab_Index = #self.Tabs + 1
    local Is_First = Tab_Index == 1

    local Tab_Button = Create_Instance('TextButton', {
        Name = Name,
        Size = UDim2.fromOffset(0, 28),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Is_First and Theme.Accent_Muted or Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = Is_First and 0 or 1,
        BorderSizePixel = 0,
        FontFace = Font_Ref(Enum.FontWeight.SemiBold),
        TextSize = 13,
        Text = Name,
        TextColor3 = Is_First and Theme_Ref('Accent') or Theme_Ref('Dim'),
        LayoutOrder = Tab_Index,
        ZIndex = 12,
        AutoButtonColor = false,
    }, self.Tab_Bar)

    Create_Corner(Tab_Button, 6)
    Create_Instance('UIPadding', {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
    }, Tab_Button)

    if Icon and Icon ~= '' then
        Tab_Button.Text = ''
        local Content = Create_Instance('Frame', {
            Name = 'Content',
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(0, 16),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            ZIndex = 13,
        }, Tab_Button)

        Create_Instance('UIListLayout', {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 4),
            VerticalAlignment = Enum.VerticalAlignment.Center,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, Content)

        local Image = Create_Instance('ImageLabel', {
            Name = 'Icon',
            Size = UDim2.fromOffset(16, 16),
            BackgroundTransparency = 1,
            Image = 'rbxassetid://' .. Icon,
            ImageColor3 = Is_First and Theme.Accent or Theme.Dim,
            LayoutOrder = 1,
            ZIndex = 13,
        }, Content)

        local Label = Create_Instance('TextLabel', {
            Name = 'Label',
            Size = UDim2.fromOffset(0, 16),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 13,
            Text = Name,
            TextColor3 = Is_First and Theme.Accent or Theme.Dim,
            LayoutOrder = 2,
            ZIndex = 13,
        }, Content)

        Tab_Button:GetPropertyChangedSignal('TextColor3'):Connect(function()
            Image.ImageColor3 = Tab_Button.TextColor3
            Label.TextColor3 = Tab_Button.TextColor3
        end)
    end

    local Underline = Create_Instance('Frame', {
        Name = 'Underline',
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -1),
        Size = Is_First and UDim2.new(1, -8, 0, 2) or UDim2.new(0, 0, 0, 2),
        BackgroundColor3 = Theme_Ref('Accent'),
        BackgroundTransparency = Is_First and 0 or 1,
        BorderSizePixel = 0,
        ZIndex = 13,
    }, Tab_Button)

    Create_Corner(Underline, 2)

    Tab_Button.MouseEnter:Connect(function()
        if self.Active_Tab ~= Tab_Index then Create_Tween(Tab_Button, 0.12, {TextColor3 = Theme.Muted}) end
    end)

    Tab_Button.MouseLeave:Connect(function()
        if self.Active_Tab ~= Tab_Index then Create_Tween(Tab_Button, 0.12, {TextColor3 = Theme.Dim}) end
    end)

    table.insert(self.Tab_Buttons, Tab_Button)
    self.Tab_Icons[Tab_Index] = (Icon and Icon ~= '') and Tab_Button.Content.Icon or nil

    local Captured_Index = Tab_Index

    Tab_Button.MouseButton1Click:Connect(function()
        if self.Search_Input and self.Search_Input.Text ~= '' then self.Search_Input.Text = '' end
        self:Switch_Tab(Captured_Index)
    end)

    local Pane = Create_Instance('CanvasGroup', {
        Name = Name .. ' Pane',
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        GroupTransparency = 1,
        Visible = Is_First,
        Position = Is_First and UDim2.fromScale(0, 0.04) or UDim2.fromScale(0, 0),
        ZIndex = 12,
    }, self.Body)

    Create_Instance('UIPadding', {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14),
    }, Pane)

    Create_Instance('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Top,
    }, Pane)

    table.insert(self.Tabs, Pane)

    if Is_First then
        task.spawn(function()
            task.wait(0.05)
            Create_Tween(Pane, 0.30, {
                GroupTransparency = 0,
                Position = UDim2.fromScale(0, 0),
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end)
    end

    local function Make_Column(Order_Number)
        local Column = Create_Instance('Frame', {
            Name = 'Section',
            Size = UDim2.new(0.5, -6, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = Order_Number,
            ZIndex = 12,
        }, Pane)

        Create_Instance('UIListLayout', {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
        }, Column)
        return Column
    end

    local Left_Column = Make_Column(1)
    local Right_Column = Make_Column(2)

    local Tab = {}
    local Order_Left, Order_Right = 0, 0

    local function Target_Column(Section)
        if type(Section) == 'table' then
            return Section.Frame
        end
        if Section == 'right' then return Right_Column end
        return Left_Column
    end

    local function Next_Order(Section)
        if type(Section) == 'table' then
            Section.Order = Section.Order + 1
            return Section.Order
        end
        if Section == 'right' then Order_Right += 1; return Order_Right end
        Order_Left += 1; return Order_Left
    end

    local function Register_Search(Object, Search_Name, Search_Info, Search_Flag)
        local Combined = table.concat({
            tostring(Search_Name or ''),
            tostring(Search_Info or ''),
            tostring(Search_Flag or ''),
        }, ' ')
        table.insert(self.Search_Items, {Object = Object, Name = Combined, Tab_Index = Tab_Index})
    end

    local function Row_Frame(Height, Section)
        local Row = Create_Instance('Frame', {
            Size = UDim2.new(1, 0, 0, Height),
            BackgroundColor3 = Theme_Ref('Panel_2'),
            BorderSizePixel = 0,
            LayoutOrder = Next_Order(Section),
            ZIndex = 15,
        }, Target_Column(Section))
        Create_Corner(Row, 8)
        local Row_Stroke = Create_Stroke(Row, 'Border', 1, 0.5)
        return Row, Row_Stroke
    end

    local function Row_Header(Parent, Name, Badge, Y_Offset)
        local Head = Create_Instance('Frame', {
            Position = UDim2.fromOffset(14, Y_Offset or 9),
            Size = UDim2.fromOffset(360, 18),
            BackgroundTransparency = 1,
            ZIndex = 16,
        }, Parent)

        Create_Instance('UIListLayout', {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 6),
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, Head)

        Create_Instance('TextLabel', {
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, 18),
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 14,
            Text = Name,
            TextColor3 = Theme_Ref('Text'),
            LayoutOrder = 1,
            ZIndex = 16,
        }, Head)

        if Badge then
            local Badge_Color = Badge_Colors[Badge] or Badge_Colors.New
            local Badge_Label = Create_Instance('TextLabel', {
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2.fromOffset(0, 16),
                BackgroundColor3 = Badge_Color.Background,
                FontFace = Font_Ref(Enum.FontWeight.SemiBold),
                TextSize = 10,
                Text = Badge,
                TextColor3 = Badge_Color.Text,
                LayoutOrder = 2,
                ZIndex = 16,
            }, Head)

            Create_Instance('UIPadding', {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}, Badge_Label)
            Create_Corner(Badge_Label, 4)
            Create_Instance('UIStroke', {Color = Badge_Color.Border, Thickness = 1, Transparency = 0.5}, Badge_Label)
        end
    end

    function Tab.Create_Title(Options)
        local Title_Object = Create_Instance('TextLabel', {
            Name = 'Title',
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 13,
            Text = Options.name or '',
            TextColor3 = Theme_Ref('Accent'),
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = Next_Order(Options.section),
            ZIndex = 15,
        }, Target_Column(Options.section))
        Register_Search(Title_Object, '')
        return Title_Object
    end

    function Tab.Create_Label(Options)
        local Label = Create_Instance('TextLabel', {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 11,
            Text = Options.name or '',
            TextColor3 = Theme_Ref('Dim'),
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = Next_Order(Options.section),
            ZIndex = 15,
        }, Target_Column(Options.section))
        Create_Instance('UIPadding', {PaddingLeft = UDim.new(0, 4)}, Label)
        Register_Search(Label, Options.name)
        return Label
    end

    function Tab.Create_Paragraph(Options)
        local Row = Create_Instance('Frame', {
            Name = 'Paragraph',
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Theme_Ref('Panel_2'),
            BorderSizePixel = 0,
            LayoutOrder = Next_Order(Options.section),
            ZIndex = 15,
        }, Target_Column(Options.section))

        Create_Corner(Row, 8)
        Create_Stroke(Row, 'Border', 1, 0.5)

        Create_Instance('UIPadding', {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 12),
        }, Row)

        Create_Instance('UIListLayout', {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
        }, Row)

        local Head = Create_Instance('Frame', {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            ZIndex = 16,
        }, Row)

        Create_Instance('UIListLayout', {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 6),
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, Head)

        Create_Instance('TextLabel', {
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, 18),
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 14,
            Text = Options.title or '',
            TextColor3 = Theme_Ref('Accent'),
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 1,
            ZIndex = 16,
        }, Head)

        if Options.badge then
            local Badge_Color = Badge_Colors[Options.badge] or Badge_Colors.New
            local Badge_Label = Create_Instance('TextLabel', {
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2.fromOffset(0, 16),
                BackgroundColor3 = Badge_Color.Background,
                FontFace = Font_Ref(Enum.FontWeight.SemiBold),
                TextSize = 10,
                Text = Options.badge,
                TextColor3 = Badge_Color.Text,
                LayoutOrder = 2,
                ZIndex = 16,
            }, Head)
            Create_Instance('UIPadding', {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}, Badge_Label)
            Create_Corner(Badge_Label, 4)
            Create_Instance('UIStroke', {Color = Badge_Color.Border, Thickness = 1, Transparency = 0.5}, Badge_Label)
        end

        Create_Instance('TextLabel', {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = Options.content or '',
            TextColor3 = Theme_Ref('Muted'),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            RichText = true,
            LineHeight = 1.15,
            LayoutOrder = 2,
            ZIndex = 16,
        }, Row)

        Register_Search(Row, Options.title, Options.content, Options.flag)
        return Row
    end

    function Tab.Create_Divider(Options)
        Options = Options or {}

        local Column = Target_Column(Options.section)
        local Order = Next_Order(Options.section)

        local Divider = Create_Instance('Frame', {
            Name = 'Divider',
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(0, 0, 0, 1),
            BackgroundColor3 = Options.color or Theme.Accent,
            BorderSizePixel = 0,
            LayoutOrder = Order,
            ZIndex = 15,
        }, Column)

        local Gradient = Create_Instance('UIGradient', {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Theme.Panel),
                ColorSequenceKeypoint.new(0.15, Options.color or Theme.Accent),
                ColorSequenceKeypoint.new(0.85, Options.color or Theme.Accent),
                ColorSequenceKeypoint.new(1, Theme.Panel),
            }),
            Transparency = NumberSequence.new(0),
            Rotation = 0,
        }, Divider)

        local function Play()
            Divider.Size = UDim2.new(0, 0, 0, 1)
            Create_Tween(Divider, 0.35, {
                Size = UDim2.new(1, 0, 0, 1),
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end
        Divider:SetAttribute('IsDivider', true)
        Divider:GetAttributeChangedSignal('Replay'):Connect(function() Play() end)
        task.spawn(function() task.wait(0.05) Play() end)
        Register_Search(Divider, '')
        return Divider
    end

    function Tab.Create_Image(Options)
        local Height = (Options.size and Options.size[2]) or 100

        local Row = Create_Instance('Frame', {
            Name = 'Thumbnail',
            Size = UDim2.new(1, 0, 0, Height),
            BackgroundColor3 = Theme_Ref('Panel_2'),
            BorderSizePixel = 0,
            LayoutOrder = Next_Order(Options.section),
            ZIndex = 15,
        }, Target_Column(Options.section))

        Create_Corner(Row, 8)
        Create_Stroke(Row, 'Border', 1, 0.5)

        local Picture = Create_Instance('ImageLabel', {
            Name = 'Picture',
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Image = 'rbxassetid://' .. (Options.image or '137740310403393'),
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 16,
        }, Row)

        Create_Corner(Picture, 8)

        local Fade = Create_Instance('Frame', {
            Name = 'Gradient',
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 0, 1, 0),
            Size = UDim2.new(1, 0, 0.6, 0),
            BackgroundColor3 = Theme_Ref('Panel'),
            BorderSizePixel = 0,
            ZIndex = 17,
        }, Row)

        Create_Instance('UIGradient', {
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0),
            }),
        }, Fade)

        Create_Corner(Fade, 8)
        Register_Search(Row, Options.name or 'Image')
        return Row
    end

    function Tab.Create_Playerlist(Options)
        local Flag = Options.flag or Options.name

        local Saved_Value = self.Saved_Config and self.Saved_Config[Flag]
        local Saved_User_Id = tonumber(Saved_Value)

        local Row_Height = 30
        local Max_Visible = 5
        local List_Height = Max_Visible * Row_Height

        local Diddy = Row_Frame(List_Height + 38, Options.section)
        Diddy.Name = Flag
        Diddy.ClipsDescendants = true

        local Head = Create_Instance('Frame', {
            Position = UDim2.fromOffset(14, 9),
            Size = UDim2.new(1, -28, 0, 18),
            BackgroundTransparency = 1,
            ZIndex = 16,
        }, Diddy)

        Create_Instance('TextLabel', {
            AnchorPoint = Vector2.new(0, 0),
            Size = UDim2.fromOffset(160, 18),
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 14,
            Text = Options.name or 'Players',
            TextColor3 = Theme_Ref('Text'),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 16,
        }, Head)

        local Count_Label = Create_Instance('TextLabel', {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, 0, 0, 0),
            Size = UDim2.fromOffset(140, 18),
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = 'Online: 0',
            TextColor3 = Theme_Ref('Dim'),
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 16,
        }, Head)

        local List = Create_Instance('ScrollingFrame', {
            Name = 'List',
            Position = UDim2.fromOffset(14, 34),
            Size = UDim2.new(1, -28, 0, List_Height),
            BackgroundColor3 = Theme_Ref('Panel'),
            BorderSizePixel = 0,
            ClipsDescendants = true,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme_Ref('Accent'),
            ScrollingDirection = Enum.ScrollingDirection.Y,
            ZIndex = 16,
        }, Diddy)

        Create_Corner(List, 6)
        Create_Stroke(List, 'Border', 1, 0.5)

        Create_Instance('UIListLayout', {
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, List)

        Create_Instance('UIPadding', {
            PaddingTop = UDim.new(0, 3),
            PaddingBottom = UDim.new(0, 3),
        }, List)

        local Empty_Label = Create_Instance('TextLabel', {
            Name = 'Empty State',
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, -16, 0, 18),
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = 'Server is empty',
            TextColor3 = Theme_Ref('Dim'),
            Visible = true,
            ZIndex = 17,
        }, List)

        local Rows = {}
        local Selected_User_Id = nil
        local Desired_User_Id = Saved_User_Id

        local function Set_Status_Selection(Player_Name, Is_Selected)
            self:Status((Is_Selected and 'Selected: ' or 'Unselected: ') .. Player_Name, Is_Selected and Theme.Accent or Theme.Dim, 1.4)
        end

        local function Update_Count()
            Count_Label.Text = 'Online: ' .. tostring(#Players:GetPlayers())
        end

        local function Update_Empty_State()
            Empty_Label.Visible = next(Rows) == nil
        end

        local function Render_Row_State(Row_Data, Is_Selected, Animate)
            if Animate then
                Create_Tween(Row_Data.Dot, 0.14, {
                    Size = Is_Selected and UDim2.fromOffset(6, 6) or UDim2.fromOffset(0, 0),
                }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                Create_Tween(Row_Data.Name_Label, 0.14, {
                    Position = Is_Selected and UDim2.fromOffset(24, 0) or UDim2.fromOffset(8, 0),
                    TextColor3 = Is_Selected and Theme.Accent or Theme.Dim,
                }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            else
                Row_Data.Dot.Size = Is_Selected and UDim2.fromOffset(6, 6) or UDim2.fromOffset(0, 0)
                Row_Data.Name_Label.Position = Is_Selected and UDim2.fromOffset(24, 0) or UDim2.fromOffset(8, 0)
                Row_Data.Name_Label.TextColor3 = Is_Selected and Theme.Accent or Theme.Dim
            end
        end

        local function Apply_Selection(Player, Silent, Animate)
            local New_User_Id = Player and Player.UserId or nil

            if Selected_User_Id and Rows[Selected_User_Id] then
                Render_Row_State(Rows[Selected_User_Id], false, Animate)
            end

            Selected_User_Id = New_User_Id
            Desired_User_Id = New_User_Id
            self.Flags[Flag] = New_User_Id

            if New_User_Id and Rows[New_User_Id] then
                Render_Row_State(Rows[New_User_Id], true, Animate)
            end

            if not Silent then
                if Player then
                    Set_Status_Selection(Player.DisplayName, true)
                end
                if Options.callback then
                    pcall(Options.callback, Player)
                end
            end
        end

        local function Make_Row(Player)
            local Row = Create_Instance('Frame', {
                Name = tostring(Player.UserId),
                Size = UDim2.new(1, 0, 0, Row_Height),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = 0,
                ZIndex = 17,
                ClipsDescendants = true,
            }, List)

            local Dot = Create_Instance('Frame', {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0, 13, 0.5, 0),
                Size = UDim2.fromOffset(0, 0),
                BackgroundColor3 = Theme_Ref('Accent'),
                BorderSizePixel = 0,
                ZIndex = 18,
            }, Row)

            Create_Corner(Dot, 3)

            local Name_Label = Create_Instance('TextLabel', {
                Position = UDim2.fromOffset(8, 0),
                Size = UDim2.new(1, -18, 1, 0),
                BackgroundTransparency = 1,
                FontFace = Font_Ref(Enum.FontWeight.SemiBold),
                TextSize = 12,
                Text = Player.DisplayName ~= Player.Name and (Player.DisplayName .. ' (' .. Player.Name .. ')') or Player.Name,
                TextColor3 = Theme_Ref('Dim'),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 18,
            }, Row)

            local Click = Create_Instance('TextButton', {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = '',
                ZIndex = 19,
                AutoButtonColor = false,
            }, Row)

            local Row_Data = {
                Row = Row,
                Dot = Dot,
                Name_Label = Name_Label,
                Player = Player,
            }

            Click.MouseButton1Click:Connect(function()
                if Selected_User_Id == Player.UserId then
                    local Left_Player = Player
                    Apply_Selection(nil, false, true)
                    Set_Status_Selection(Left_Player.DisplayName, false)
                    self:Autosave()
                else
                    Apply_Selection(Player, false, true)
                    self:Autosave()
                end
            end)

            Render_Row_State(Row_Data, Selected_User_Id == Player.UserId, false)
            return Row_Data
        end

        local function Sort_Rows()
            local Order_List = {}
            for _, Row_Data in pairs(Rows) do
                table.insert(Order_List, Row_Data)
            end

            table.sort(Order_List, function(A, B)
                return A.Player.Name:lower() < B.Player.Name:lower()
            end)

            for Index, Row_Data in ipairs(Order_List) do
                Row_Data.Row.LayoutOrder = Index
            end
        end

        local function Add_Player(Player, Animate)
            if Player == Player then return end
            if Rows[Player.UserId] then return end

            local Row_Data = Make_Row(Player)
            Rows[Player.UserId] = Row_Data

            Sort_Rows()
            Update_Count()
            Update_Empty_State()

            if Animate then
                Row_Data.Row.Size = UDim2.new(1, 0, 0, 0)
                Create_Tween(Row_Data.Row, 0.2, {
                    Size = UDim2.new(1, 0, 0, Row_Height),
                })
            end

            if Desired_User_Id and Desired_User_Id == Player.UserId and Selected_User_Id == nil then
                Apply_Selection(Player, true, false)
                if Options.callback then
                    pcall(Options.callback, Player)
                end
            end
        end

        local function Remove_Player(Player, Animate)
            local Row_Data = Rows[Player.UserId]
            if not Row_Data then return end

            Rows[Player.UserId] = nil
            Update_Count()
            Update_Empty_State()

            if Selected_User_Id == Player.UserId then
                Selected_User_Id = nil
                self.Flags[Flag] = Desired_User_Id

                if Options.callback then
                    pcall(Options.callback, nil)
                end
            end

            if Animate then
                Create_Tween(Row_Data.Row, 0.18, {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                })

                Create_Tween(Row_Data.Name_Label, 0.15, {
                    TextTransparency = 1,
                })

                Create_Tween(Row_Data.Dot, 0.15, {
                    BackgroundTransparency = 1,
                })

                task.delay(0.2, function()
                    if Row_Data.Row then
                        Row_Data.Row:Destroy()
                    end
                end)
            else
                Row_Data.Row:Destroy()
            end
        end

        for _, Player in ipairs(Players:GetPlayers()) do
            Add_Player(Player, false)
        end

        Update_Count()
        Update_Empty_State()

        Connection['Added' .. Flag] = Players.PlayerAdded:Connect(function(Player) Add_Player(Player, true) end)
        Connection['Removed' .. Flag] = Players.PlayerRemoving:Connect(function(Player) Remove_Player(Player, true) end)

        self.Flags[Flag] = Selected_User_Id

        self.Control_Objects[Flag] = {
            Kind = 'playerlist',
            Apply = function(Value, Silent)
                local Target_Id = tonumber(Value)
                local Target_Player = nil

                if Target_Id then
                    for _, Row_Data in pairs(Rows) do
                        if Row_Data.Player.UserId == Target_Id then
                            Target_Player = Row_Data.Player
                            break
                        end
                    end
                end
                Apply_Selection(Target_Player, Silent, true)
            end,
        }

        Register_Search(Diddy, Options.name or Flag, nil, Flag)

        if Options.callback then
            local Initial_Player = nil
            if Selected_User_Id then
                for _, Row_Data in pairs(Rows) do
                    if Row_Data.Player.UserId == Selected_User_Id then
                        Initial_Player = Row_Data.Player
                        break
                    end
                end
            end
            pcall(Options.callback, Initial_Player)
        end
    end

    function Tab.Create_Button(Options)
        local Has_Description = Options.info and Options.info ~= ''
        local Row = Row_Frame(Has_Description and 52 or 40, Options.section)
        Row.Name = Options.name or 'Button'
        Row_Header(Row, Options.name or 'Button', Options.badge, Has_Description and 9 or 11)

        if Has_Description then
            Create_Instance('TextLabel', {
                Position = UDim2.fromOffset(14, 30),
                Size = UDim2.fromOffset(300, 14),
                BackgroundTransparency = 1,
                FontFace = Font_Ref(Enum.FontWeight.SemiBold),
                TextSize = 11,
                Text = Options.info or '',
                TextColor3 = Theme_Ref('Dim'),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 16,
            }, Row)
        end

        local Action_Button = Create_Instance('TextButton', {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(76, 26),
            BackgroundColor3 = Theme_Ref('Accent_Muted'),
            BorderSizePixel = 0,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = '▶  Run',
            TextColor3 = Theme_Ref('Accent'),
            ZIndex = 18,
            AutoButtonColor = false,
        }, Row)

        Create_Corner(Action_Button, 6)
        Create_Stroke(Action_Button, 'Accent', 1, 0.5)

        Action_Button.MouseEnter:Connect(function()
            Create_Tween(Action_Button, 0.12, {BackgroundColor3 = Theme.Accent})
        end)
        Action_Button.MouseLeave:Connect(function()
            Create_Tween(Action_Button, 0.12, {BackgroundColor3 = Theme.Accent_Muted})
        end)
        Action_Button.MouseButton1Click:Connect(function()
            Create_Tween(Action_Button, 0.08, {Size = UDim2.fromOffset(70, 24)})
            task.delay(0.08, function() Create_Tween(Action_Button, 0.12, {Size = UDim2.fromOffset(76, 26)}, Spring_Style, Spring_Direction) end)
            self:Status('Ran: ' .. (Options.name or 'Button'), Theme.Accent, 1.2)
            if Options.callback then pcall(Options.callback) end
        end)

        Register_Search(Row, Options.name, Options.info, Options.flag)
        return Row
    end

    function Tab.Create_Toggle(Options)
        local Flag = Options.flag or Options.name
        local Default

        if self.Saved_Config and self.Saved_Config[Flag] ~= nil then
            Default = self.Saved_Config[Flag] == true
        else
            Default = Options.enabled == true
        end

        local Has_Description = Options.info and Options.info ~= ''

        local Row = Row_Frame(Has_Description and 52 or 40, Options.section)
        Row.Name = Flag
        Row_Header(Row, Options.name or Flag, Options.badge, Has_Description and 9 or 11)

        if Has_Description then
            Create_Instance('TextLabel', {
                Position = UDim2.fromOffset(14, 30),
                Size = UDim2.fromOffset(300, 14),
                BackgroundTransparency = 1,
                FontFace = Font_Ref(Enum.FontWeight.SemiBold),
                TextSize = 11,
                Text = Options.info or '',
                TextColor3 = Theme_Ref('Dim'),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 16,
            }, Row)
        end

        local Track = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(42, 22),
            BackgroundColor3 = Default and Theme.Accent or Theme.Not_Enabled,
            BorderSizePixel = 0,
            ZIndex = 16,
        }, Row)

        Create_Corner(Track, 11)

        local Thumb = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = Default and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
            Size = UDim2.fromOffset(16, 16),
            BackgroundColor3 = Theme_Ref('White'),
            BorderSizePixel = 0,
            ZIndex = 17,
        }, Track)

        Create_Corner(Thumb, 8)

        local State = Default

        local function Render(Value)
            Create_Tween(Track, 0.22, {BackgroundColor3 = Value and Theme.Accent or Theme.Not_Enabled})
            Create_Tween(Thumb, 0.30, {Position = Value and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)}, Spring_Style, Spring_Direction)
        end

        local function Apply(Value, Silent)
            Value = Value and true or false
            State = Value
            self.Flags[Flag] = Value
            Render(Value)
            if not Silent and Options.callback then pcall(Options.callback, Value) end
        end

        self.Flags[Flag] = Default
        self.Control_Objects[Flag] = {Kind = 'toggle', Apply = Apply}

        Render(Default)
        Register_Theme_Refresh(Track, function() Render(State) end)

        if Options.callback then
            pcall(Options.callback, Default)
        end

        local Click_Button = Create_Instance('TextButton', {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = '',
            ZIndex = 18,
        }, Row)

        Click_Button.MouseButton1Click:Connect(function()
            Apply(not State, false)
            self:Status((State and 'Enabled: ' or 'Disabled: ') .. (Options.name or Flag),
                State and Theme.Accent or Theme.Dim, 1.4)
            self:Autosave()
        end)

        Register_Search(Row, Options.name or Flag, Options.info, Flag)
        return Track
    end

    function Tab.Create_Slider(Options)
        local Flag = Options.flag or Options.name
        local Min = Options.min or 0
        local Max = Options.max or 100

        local Step = Options.step
        if Step == nil or Step <= 0 then
            Step = 0
        end

        local Decimals = Options.decimals
        if Decimals == nil then
            if Step > 0 then
                Decimals = math.max(0, -math.floor(math.log10(Step)))
            else
                Decimals = 0
            end
        end

        local Suffix = Options.suffix or ''

        local function Snap(Value)
            local Number = tonumber(Value)
            if not Number then return nil end
            if Step and Step > 0 then
                local Steps = math.floor((Number - Min) / Step + 0.5)
                Number = Min + Steps * Step
            end
            local Multiplier = 10 ^ Decimals
            Number = math.floor(Number * Multiplier + 0.5) / Multiplier
            return math.clamp(Number, Min, Max)
        end

        local Saved_Value = self.Saved_Config and self.Saved_Config[Flag]
        local Default = Snap(Saved_Value)
        if Default == nil then
            Default = Snap(Options.default) or Min
        end

        local Row = Row_Frame(56, Options.section)
        Row.Name = Flag
        Row_Header(Row, Options.name or Flag, Options.badge, 9)

        local Value_Label = Create_Instance('TextLabel', {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -14, 0, 9),
            Size = UDim2.fromOffset(120, 18),
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 13,
            Text = '',
            TextColor3 = Theme_Ref('Accent'),
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 16,
        }, Row)

        local Bar_Background = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 14, 1, -16),
            Size = UDim2.new(1, -28, 0, 6),
            BackgroundColor3 = Theme_Ref('Not_Enabled'),
            BorderSizePixel = 0,
            ZIndex = 16,
        }, Row)

        Create_Corner(Bar_Background, 3)

        local Fill = Create_Instance('Frame', {
            Size = UDim2.fromScale(0, 1),
            BackgroundColor3 = Theme_Ref('Accent'),
            BorderSizePixel = 0,
            ZIndex = 17,
        }, Bar_Background)

        Create_Corner(Fill, 3)

        local Knob = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.fromOffset(14, 14),
            BackgroundColor3 = Theme_Ref('White'),
            BorderSizePixel = 0,
            ZIndex = 18,
        }, Bar_Background)

        Create_Corner(Knob, 7)
        Create_Stroke(Knob, 'Accent', 2, 0)

        local Current_Value = Default

        local function Set_Value(Value, Silent, Instant)
            local Number = Snap(Value)
            if Number == nil then return end
            Current_Value = Number
            self.Flags[Flag] = Number
            local Alpha = (Max == Min) and 0 or (Number - Min) / (Max - Min)
            Value_Label.Text = tostring(Number) .. Suffix
            if Instant then
                Create_Tween(Fill, 0.045, {Size = UDim2.fromScale(Alpha, 1)}, Enum.EasingStyle.Linear)
                Create_Tween(Knob, 0.045, {Position = UDim2.fromScale(Alpha, 0.5)}, Enum.EasingStyle.Linear)
            else
                Create_Tween(Fill, 0.12, {Size = UDim2.fromScale(Alpha, 1)}, Enum.EasingStyle.Quint)
                Create_Tween(Knob, 0.12, {Position = UDim2.fromScale(Alpha, 0.5)}, Enum.EasingStyle.Quint)
            end
            if not Silent and Options.callback then pcall(Options.callback, Number) end
        end

        self.Flags[Flag] = Default
        self.Control_Objects[Flag] = {Kind = 'slider', Apply = function(Value, Silent) Set_Value(Value, Silent, false) end}
        Register_Theme_Refresh(Bar_Background, function() Set_Value(Current_Value, true, true) end)

        local Dragging = false
        local function Value_From_X(Pixel_X)
            local Absolute_X = Bar_Background.AbsolutePosition.X
            local Width = Bar_Background.AbsoluteSize.X
            return Min + math.clamp((Pixel_X - Absolute_X) / math.max(Width, 1), 0, 1) * (Max - Min)
        end

        local Hit_Area = Create_Instance('TextButton', {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1.09, 0, 0, 25),
            BackgroundTransparency = 1,
            Text = '',
            ZIndex = 19,
            AutoButtonColor = false,
        }, Bar_Background)

        Hit_Area.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                Set_Value(Value_From_X(Input.Position.X), false, true)
            end
        end)

        Connection['Slider_End_' .. Flag] = UserInputService.InputEnded:Connect(function(Input)
            if (Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch) and Dragging then
                Dragging = false
                self:Autosave()
            end
        end)

        Connection['Slider_Drag_' .. Flag] = UserInputService.InputChanged:Connect(function(Input)
            if not Dragging then return end
            if Input.UserInputType ~= Enum.UserInputType.MouseMovement
            and Input.UserInputType ~= Enum.UserInputType.Touch then return end
            Set_Value(Value_From_X(Input.Position.X), false, true)
        end)

        Set_Value(Default, true, true)

        if Options.callback then
            pcall(Options.callback, Default)
        end

        Register_Search(Row, Options.name or Flag, nil, Flag)
        return Row
    end

    function Tab.Create_Dropdown(Options)
        local Flag = Options.flag or Options.name
        local Choices = Options.options or {}
        local Is_Multi = Options.multi == true
        local Saved_Value = self.Saved_Config and self.Saved_Config[Flag]

        local Selected_Set = {}
        local Selected_Order = {}

        local function Add_Selected(Value)
            if Selected_Set[Value] then return end
            Selected_Set[Value] = true
            table.insert(Selected_Order, Value)
        end

        local function Remove_Selected(Value)
            if not Selected_Set[Value] then return end
            Selected_Set[Value] = nil
            for Index, Existing_Value in ipairs(Selected_Order) do
                if Existing_Value == Value then
                    table.remove(Selected_Order, Index)
                    break
                end
            end
        end

        if Is_Multi then
            local Initial = Saved_Value
            if Initial == nil then Initial = Options.default end
            if type(Initial) == 'table' then
                for _, Value in ipairs(Initial) do Add_Selected(tostring(Value)) end
            end
        end

        local Default_Single
        if not Is_Multi then
            Default_Single = Saved_Value ~= nil and Saved_Value or (Options.default or Choices[1])
        end

        local Row_Height = 28
        local Max_List = math.min(#Choices, 5)
        local Needs_Scroll = #Choices > 5

        local Row = Row_Frame(46, Options.section)
        Row.Name = Flag
        Row_Header(Row, Options.name or Flag, Options.badge, 14)

        local Box = Create_Instance('TextButton', {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -14, 0, 9),
            Size = UDim2.fromOffset(140, 28),
            BackgroundColor3 = Theme_Ref('Not_Enabled'),
            BorderSizePixel = 0,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = '',
            TextColor3 = Theme_Ref('Text'),
            ZIndex = 17,
            AutoButtonColor = false,
        }, Row)

        Create_Corner(Box, 6)
        Create_Stroke(Box, 'Border', 1, 0.5)

        local Selected_Label = Create_Instance('TextLabel', {
            Position = UDim2.fromOffset(10, 0),
            Size = UDim2.new(1, -34, 1, 0),
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = '',
            TextColor3 = Theme_Ref('Text'),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 18,
        }, Box)

        local Arrow = Create_Instance('TextLabel', {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -8, 0.5, 0),
            Size = UDim2.fromOffset(14, 14),
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = '▼',
            TextColor3 = Theme_Ref('Muted'),
            ZIndex = 18,
        }, Box)

        local List = Create_Instance('ScrollingFrame', {
            Position = UDim2.new(0, 14, 0, 46),
            Size = UDim2.new(1, -28, 0, 0),
            BackgroundColor3 = Theme_Ref('Panel'),
            BorderSizePixel = 0,
            ClipsDescendants = true,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Needs_Scroll and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
            ScrollBarThickness = Needs_Scroll and 4 or 0,
            ScrollBarImageColor3 = Theme_Ref('Accent'),
            ScrollingDirection = Enum.ScrollingDirection.Y,
            ScrollingEnabled = Needs_Scroll,
            ZIndex = 19,
        }, Row)

        Create_Corner(List, 6)
        Create_Stroke(List, 'Border', 1, 0.5)
        Create_Instance('UIListLayout', {SortOrder = Enum.SortOrder.LayoutOrder}, List)
        Create_Instance('UIPadding', {PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3)}, List)

        local Is_Open = false
        local Full_Height = Max_List * Row_Height + 6
        if Is_Multi then
            Full_Height = Full_Height + 26
        end

        local function Close()
            if not Is_Open then return end
            Is_Open = false
            self.Open_Dropdown = nil
            List.Visible = false
            List.CanvasPosition = Vector2.new(0, 0)
            Create_Tween(Arrow, 0.18, {Rotation = 0})
            Create_Tween(List, 0.20, {Size = UDim2.new(1, -28, 0, 0)})
            Create_Tween(Row, 0.22, {Size = UDim2.new(1, 0, 0, 46)})
        end

        List.Visible = false
        List.Size = UDim2.new(1, -28, 0, 0)
        List.CanvasPosition = Vector2.new(0, 0)

        local Item_Objects = {}

        local function Get_Multi_Array()
            local Array = {}
            for _, Value in ipairs(Selected_Order) do table.insert(Array, Value) end
            return Array
        end

        local function Refresh_Label()
            if Is_Multi then
                if #Selected_Order == 0 then
                    Selected_Label.Text = 'None selected'
                elseif #Selected_Order == 1 then
                    Selected_Label.Text = Selected_Order[1]
                else
                    Selected_Label.Text = #Selected_Order .. ' selected'
                end
            else
                Selected_Label.Text = tostring(Default_Single)
            end
        end

        local function Refresh_Item_Colors()
            for Value, Item in pairs(Item_Objects) do
                local Is_Selected
                if Is_Multi then
                    Is_Selected = Selected_Set[Value] == true
                else
                    Is_Selected = (Value == tostring(Default_Single))
                end
                Item.TextColor3 = Is_Selected and Theme.Accent or Theme.Muted
                if Is_Multi then
                    Item.BackgroundColor3 = Theme.Accent_Muted
                    Item.BackgroundTransparency = Is_Selected and 0 or 1
                end
            end
        end

        local function Set_Single_Value(Value, Silent)
            Default_Single = Value
            self.Flags[Flag] = Value
            Refresh_Label()
            Refresh_Item_Colors()
            if not Silent and Options.callback then pcall(Options.callback, Value) end
        end

        local function Set_Multi_Value(Array, Silent)
            Selected_Set = {}
            Selected_Order = {}
            if type(Array) == 'table' then
                for _, Value in ipairs(Array) do Add_Selected(tostring(Value)) end
            end
            self.Flags[Flag] = Get_Multi_Array()
            Refresh_Label()
            Refresh_Item_Colors()
            if not Silent and Options.callback then pcall(Options.callback, Get_Multi_Array()) end
        end

        local function Toggle_Multi_Value(Value, Silent)
            if Selected_Set[Value] then
                Remove_Selected(Value)
            else
                Add_Selected(Value)
            end
            self.Flags[Flag] = Get_Multi_Array()
            Refresh_Label()
            Refresh_Item_Colors()
            if not Silent and Options.callback then pcall(Options.callback, Get_Multi_Array()) end
        end

        if Is_Multi then
            local Quick_Row = Create_Instance('Frame', {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                LayoutOrder = 0,
                ZIndex = 20,
            }, List)

            Create_Instance('UIListLayout', {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center,
            }, Quick_Row)

            Create_Instance('UIPadding', {PaddingLeft = UDim.new(0, 4), PaddingBottom = UDim.new(0, 2)}, Quick_Row)

            local Select_All_Button = Create_Instance('TextButton', {
                Size = UDim2.fromOffset(70, 18),
                BackgroundColor3 = Theme_Ref('Panel_2'),
                BorderSizePixel = 0,
                FontFace = Font_Ref(Enum.FontWeight.SemiBold),
                TextSize = 10,
                Text = 'Select All',
                TextColor3 = Theme_Ref('Muted'),
                LayoutOrder = 1,
                ZIndex = 20,
                AutoButtonColor = false,
            }, Quick_Row)
            Create_Corner(Select_All_Button, 4)

            local Clear_All_Button = Create_Instance('TextButton', {
                Size = UDim2.fromOffset(50, 18),
                BackgroundColor3 = Theme_Ref('Panel_2'),
                BorderSizePixel = 0,
                FontFace = Font_Ref(Enum.FontWeight.SemiBold),
                TextSize = 10,
                Text = 'Clear',
                TextColor3 = Theme_Ref('Muted'),
                LayoutOrder = 2,
                ZIndex = 20,
                AutoButtonColor = false,
            }, Quick_Row)
            Create_Corner(Clear_All_Button, 4)

            Select_All_Button.MouseButton1Click:Connect(function()
                local All = {}
                for _, Choice in ipairs(Choices) do table.insert(All, tostring(Choice)) end
                Set_Multi_Value(All, false)
                self:Autosave()
            end)

            Clear_All_Button.MouseButton1Click:Connect(function()
                Set_Multi_Value({}, false)
                self:Autosave()
            end)
        end

        for Index, Choice in ipairs(Choices) do
            local Choice_Text = tostring(Choice)
            local Item = Create_Instance('TextButton', {
                Size = UDim2.new(1, 0, 0, Row_Height),
                BackgroundColor3 = Theme_Ref('Accent_Muted'),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                FontFace = Font_Ref(Enum.FontWeight.SemiBold),
                TextSize = 12,
                Text = '   ' .. Choice_Text,
                TextColor3 = Theme_Ref('Muted'),
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = Index + 1,
                ZIndex = 20,
                AutoButtonColor = false,
            }, List)

            if Is_Multi then
                Create_Corner(Item, 4)
            end

            Item_Objects[Choice_Text] = Item

            Item.MouseButton1Click:Connect(function()
                if Is_Multi then
                    Toggle_Multi_Value(Choice_Text, false)
                    self:Status((Selected_Set[Choice_Text] and 'Added: ' or 'Removed: ') .. Choice_Text, Theme.Accent, 1.0)
                    self:Autosave()
                else
                    Set_Single_Value(Choice_Text, false)
                    self:Status('Selected: ' .. Choice_Text, Theme.Accent, 1.2)
                    self:Autosave()
                    if Options.trigger ~= false then
                        Close()
                    end
                end
            end)
        end

        local function Open_List()
            if Is_Open then Close() return end
            if self.Open_Dropdown then self.Open_Dropdown() end
            Is_Open = true
            self.Open_Dropdown = Close
            List.Visible = true
            List.CanvasPosition = Vector2.new(0, 0)
            Create_Tween(Arrow, 0.18, {Rotation = 180})
            Create_Tween(List, 0.22, {Size = UDim2.new(1, -28, 0, Full_Height)})
            Create_Tween(Row, 0.24, {Size = UDim2.new(1, 0, 0, 46 + Full_Height + 8)})
        end

        Box.MouseButton1Click:Connect(Open_List)

        if Is_Multi then
            self.Flags[Flag] = Get_Multi_Array()
            self.Control_Objects[Flag] = {Kind = 'multidropdown', Apply = function(Value, Silent) Set_Multi_Value(Value, Silent) end}
        else
            self.Flags[Flag] = Default_Single
            self.Control_Objects[Flag] = {Kind = 'dropdown', Apply = function(Value, Silent) Set_Single_Value(Value, Silent) end}
        end

        Refresh_Label()
        Refresh_Item_Colors()
        Register_Theme_Refresh(Box, Refresh_Item_Colors)

        if Options.callback then
            if Is_Multi then
                pcall(Options.callback, Get_Multi_Array())
            else
                pcall(Options.callback, Default_Single)
            end
        end

        Register_Search(Row, Options.name or Flag)
        return Row
    end

    function Tab.Create_Keybind(Options)
        local Flag = Options.flag or Options.name
        local Saved_Value = self.Saved_Config and self.Saved_Config[Flag]
        local Default = Options.default or Enum.KeyCode.None

        if Saved_Value ~= nil then
            Default = Enum.KeyCode[tostring(Saved_Value)] or Default
        end

        local Row = Row_Frame(46, Options.section)
        Row.Name = Flag
        Row_Header(Row, Options.name or Flag, Options.badge, 14)

        local function Key_Text(Key)
            if not Key or Key == Enum.KeyCode.None then return 'None' end
            return tostring(Key):gsub('Enum.KeyCode.', '')
        end

        local Box = Create_Instance('TextButton', {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(120, 28),
            BackgroundColor3 = Theme_Ref('Not_Enabled'),
            BorderSizePixel = 0,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = Key_Text(Default),
            TextColor3 = Theme_Ref('Text'),
            ZIndex = 17,
            AutoButtonColor = false,
        }, Row)

        Create_Corner(Box, 6)
        local Box_Stroke = Create_Stroke(Box, 'Border', 1, 0.5)

        local Current = Default

        local function Set_Key(Key, Silent)
            Current = Key
            self.Flags[Flag] = Key_Text(Key)
            Box.Text = Key_Text(Key)
            if not Silent and Options.callback then pcall(Options.callback, Key) end
        end

        Box.MouseButton1Click:Connect(function()
            Box.Text = '...'
            Create_Tween(Box_Stroke, 0.12, {Color = Theme.Accent, Transparency = 1})
            self.Capturing = function(Key_Code)
                self.Capturing = nil
                Create_Tween(Box_Stroke, 0.12, {Color = Theme.Border, Transparency = 0.3})
                if Key_Code == Enum.KeyCode.Escape then
                    Set_Key(Enum.KeyCode.None, false)
                else
                    Set_Key(Key_Code, false)
                end
                self:Status('Bound: ' .. Key_Text(Current), Theme.Accent, 1.2)
                self:Autosave()
            end
        end)

        Connection['Keybind_Input_' .. Flag] = UserInputService.InputBegan:Connect(function(Input, Game_Processed)
            if Game_Processed or self.Capturing then return end
            if Current and Current ~= Enum.KeyCode.None and Input.KeyCode == Current then
                if Options.callback then pcall(Options.callback, Current) end
            end
        end)

        self.Flags[Flag] = Key_Text(Default)
        self.Control_Objects[Flag] = {
            Kind = 'keybind',
            Apply = function(Value, Silent)
                local Key_Code = Enum.KeyCode[tostring(Value)]
                if Key_Code then Set_Key(Key_Code, Silent) end
            end,
        }

        Set_Key(Default, true)

        if Options.callback then
            pcall(Options.callback, Default)
        end

        Register_Search(Row, Options.name or Flag)
        return Row
    end

    function Tab.Create_Separator(Options)
        Options = Options or {}
        local Column = Target_Column(Options.section)
        local Order = Next_Order(Options.section)

        local Row = Create_Instance('Frame', {
            Name = 'Separator',
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            LayoutOrder = Order,
            ZIndex = 15,
        }, Column)

        local Left_Line = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.new(0, 0, 0, 1),
            BackgroundColor3 = Options.color or Theme_Ref('Border'),
            BorderSizePixel = 0,
            ZIndex = 15,
        }, Row)

        local Right_Line = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.new(0, 0, 0, 1),
            BackgroundColor3 = Options.color or Theme_Ref('Border'),
            BorderSizePixel = 0,
            ZIndex = 15,
        }, Row)

        local Label = Create_Instance('TextLabel', {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(0, 20),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 11,
            Text = Options.name or '',
            TextColor3 = Options.color or Theme_Ref('Dim'),
            ZIndex = 16,
        }, Row)

        local function Play()
            local Label_Width = Label.AbsoluteSize.X
            local Total_Width = Row.AbsoluteSize.X
            local Line_Width = math.max(0, (Total_Width - Label_Width - 12) / 2)

            Left_Line.Size = UDim2.new(0, 0, 0, 1)
            Right_Line.Size = UDim2.new(0, 0, 0, 1)

            Create_Tween(Left_Line, 0.35, {
                Size = UDim2.new(0, Line_Width, 0, 1),
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

            Create_Tween(Right_Line, 0.35, {
                Size = UDim2.new(0, Line_Width, 0, 1),
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end

        local function Snap()
            local Label_Width = Label.AbsoluteSize.X
            local Total_Width = Row.AbsoluteSize.X
            local Line_Width = math.max(0, (Total_Width - Label_Width - 12) / 2)

            Left_Line.Size = UDim2.new(0, Line_Width, 0, 1)
            Right_Line.Size = UDim2.new(0, Line_Width, 0, 1)
        end

        Row:SetAttribute('IsDivider', true)
        Row:GetAttributeChangedSignal('Replay'):Connect(function() Play() end)
        Row:GetPropertyChangedSignal('AbsoluteSize'):Connect(Snap)
        task.spawn(function() task.wait(0.05) Play() end)

        Register_Search(Row, '')
        return Row
    end

    function Tab.Create_Textbox(Options)
        local Flag = Options.flag or Options.name
        local Saved_Value = self.Saved_Config and self.Saved_Config[Flag]
        local Default = (Saved_Value ~= nil and tostring(Saved_Value)) or (Options.default or '')

        local Has_Description = Options.info and Options.info ~= ''

        local Row = Row_Frame(Has_Description and 52 or 40, Options.section)
        Row.Name = Flag
        Row_Header(Row, Options.name or Flag, Options.badge, Has_Description and 9 or 11)

        if Has_Description then
            Create_Instance('TextLabel', {
                Position = UDim2.fromOffset(14, 30),
                Size = UDim2.fromOffset(200, 14),
                BackgroundTransparency = 1,
                FontFace = Font_Ref(Enum.FontWeight.SemiBold),
                TextSize = 11,
                Text = Options.info or '',
                TextColor3 = Theme_Ref('Dim'),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 16,
            }, Row)
        end

        local Box = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(140, 26),
            BackgroundColor3 = Theme_Ref('Not_Enabled'),
            BorderSizePixel = 0,
            ZIndex = 17,
        }, Row)

        Create_Corner(Box, 6)
        local Box_Stroke = Create_Stroke(Box, 'Border', 1, 0.5)

        local Input = Create_Instance('TextBox', {
            Position = UDim2.fromOffset(8, 0),
            Size = UDim2.new(1, -16, 1, 0),
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = Default,
            PlaceholderText = Options.placeholder or 'Enter text...',
            PlaceholderColor3 = Theme_Ref('Dim'),
            TextColor3 = Theme_Ref('Text'),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ClearTextOnFocus = Options.clear_on_focus == true,
            ZIndex = 18,
        }, Box)

        local Current = Default
        self.Flags[Flag] = Current

        local function Set_Value(Text, Silent)
            Current = Text
            self.Flags[Flag] = Text
            if not Silent and Options.callback then
                pcall(Options.callback, Text)
            end
        end

        Input.Focused:Connect(function()
            Create_Tween(Box_Stroke, 0.12, {Color = Theme.Accent, Transparency = 1})
        end)

        Input.FocusLost:Connect(function(Enter_Pressed)
            Create_Tween(Box_Stroke, 0.12, {Color = Theme.Border, Transparency = 1})
            local Text = Input.Text
            if Options.max_length then
                Text = Text:sub(1, Options.max_length)
                Input.Text = Text
            end
            Set_Value(Text, false)
            self:Status((Options.name or Flag) .. ': ' .. tostring(Text), Theme.Accent, 1.2)
            self:Autosave()
        end)

        self.Flags[Flag] = Default
        self.Control_Objects[Flag] = {
            Kind = 'textbox',
            Apply = function(Value, Silent)
                Input.Text = tostring(Value or '')
                Set_Value(tostring(Value or ''), Silent)
            end,
        }

        Set_Value(Default, true)
        if Options.callback then
            pcall(Options.callback, Default)
        end
        Register_Search(Row, Options.name or Flag, Flag)
        return Row
    end

    function Tab.Create_Color_Picker(Options)
        local Flag = Options.flag or Options.name
        local Saved_Value = self.Saved_Config and self.Saved_Config[Flag]
        local Default = Options.default or Theme.Accent

        if Saved_Value ~= nil then
            local Saved_Color = typeof(Saved_Value) == 'Color3' and Saved_Value or Hex_To_Color(Saved_Value)
            if Saved_Color then
                Default = Saved_Color
            end
        end

        local Row = Row_Frame(46, Options.section)
        Row.Name = Flag
        Row_Header(Row, Options.name or Flag, Options.badge, 14)

        local Hue, Saturation, Value = Color3.toHSV(Default)
        local SV_Target_X, SV_Target_Y = Saturation, 1 - Value
        local Hue_Target = Hue

        local Swatch = Create_Instance('TextButton', {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -14, 0, 12),
            Size = UDim2.fromOffset(40, 22),
            BackgroundColor3 = Default,
            BorderSizePixel = 0,
            Text = '',
            ZIndex = 17,
            AutoButtonColor = false,
        }, Row)

        Create_Corner(Swatch, 6)
        Create_Stroke(Swatch, 'Border', 1, 0.5)

        local Icon = Create_Instance('TextLabel', {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -60, 0, 12),
            Size = UDim2.fromOffset(14, 18),
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = '▼',
            TextColor3 = Theme_Ref('Muted'),
            ZIndex = 17,
        }, Row)

        local Picker_Open_Height = 146

        local Picker = Create_Instance('Frame', {
            Position = UDim2.new(0, 14, 0, 46),
            Size = UDim2.new(1, -28, 0, 0),
            BackgroundColor3 = Theme_Ref('Panel'),
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 19,
        }, Row)

        Create_Corner(Picker, 6)
        Create_Stroke(Picker, 'Border', 1, 0.5)

        local Pad = Create_Instance('Frame', {
            Position = UDim2.fromOffset(10, 10),
            Size = UDim2.new(1, -20, 0, 90),
            BackgroundTransparency = 1,
            ZIndex = 20,
        }, Picker)

        local SV_Box = Create_Instance('Frame', {
            Size = UDim2.new(1, -26, 1, 0),
            BackgroundColor3 = Color3.fromHSV(Hue, 1, 1),
            BorderSizePixel = 0,
            ZIndex = 20,
        }, Pad)

        Create_Corner(SV_Box, 4)

        local White_Gradient = Create_Instance('Frame', {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            ZIndex = 20,
        }, SV_Box)

        Create_Corner(White_Gradient, 4)
        Create_Instance('UIGradient', {
            Transparency = NumberSequence.new(0, 1),
        }, White_Gradient)

        local Black_Gradient = Create_Instance('Frame', {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            ZIndex = 21,
        }, SV_Box)

        Create_Corner(Black_Gradient, 0)
        Create_Instance('UIGradient', {
            Rotation = 90,
            Transparency = NumberSequence.new(1, 0),
        }, Black_Gradient)

        local SV_Cursor = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(8, 8),
            BackgroundColor3 = Theme_Ref('White'),
            BorderSizePixel = 0,
            ZIndex = 22,
            Position = UDim2.fromScale(Saturation, 1 - Value),
        }, SV_Box)

        Create_Corner(SV_Cursor, 4)
        Create_Instance('UIStroke', {Color = Color3.new(0, 0, 0), Thickness = 1, Transparency = 0.2}, SV_Cursor)

        local Hue_Bar = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, 0, 0, 0),
            Size = UDim2.fromOffset(18, 90),
            BorderSizePixel = 0,
            ZIndex = 20,
        }, Pad)

        Create_Corner(Hue_Bar, 4)

        Create_Instance('UIGradient', {
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
            }),
        }, Hue_Bar)

        local Hue_Cursor = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, Hue, 0),
            Size = UDim2.new(1, 4, 0, 3),
            BackgroundColor3 = Theme_Ref('White'),
            BorderSizePixel = 0,
            ZIndex = 22,
        }, Hue_Bar)

        Create_Corner(Hue_Cursor, 2)

        local Hex_Row = Create_Instance('Frame', {
            Position = UDim2.fromOffset(10, 108),
            Size = UDim2.new(1, -20, 0, 26),
            BackgroundColor3 = Theme_Ref('Panel_2'),
            BorderSizePixel = 0,
            ZIndex = 20,
        }, Picker)

        Create_Corner(Hex_Row, 6)
        Create_Stroke(Hex_Row, 'Border', 1, 0.5)

        Create_Instance('TextLabel', {
            Position = UDim2.fromOffset(8, 0),
            Size = UDim2.fromOffset(14, 26),
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = '#',
            TextColor3 = Theme_Ref('Dim'),
            ZIndex = 21,
        }, Hex_Row)

        local Hex_Input = Create_Instance('TextBox', {
            Position = UDim2.fromOffset(22, 0),
            Size = UDim2.new(1, -30, 1, 0),
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = Color_To_Hex(Default):gsub('#', ''),
            PlaceholderText = 'RRGGBB',
            PlaceholderColor3 = Theme_Ref('Dim'),
            TextColor3 = Theme_Ref('Text'),
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
            ZIndex = 21,
        }, Hex_Row)

        local Is_Open = false
        local SV_Dragging, Hue_Dragging = false, false

        local function Recolor(Silent)
            local Color = Color3.fromHSV(Hue, Saturation, Value)
            Swatch.BackgroundColor3 = Color
            SV_Box.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
            Hex_Input.Text = Color_To_Hex(Color):gsub('#', '')
            self.Flags[Flag] = Color
            if not Silent and Options.callback then
                pcall(Options.callback, Color)
            end
        end

        local function Set_Open(State_Open)
            Is_Open = State_Open
            Create_Tween(Icon, 0.18, {Rotation = Is_Open and 180 or 0})
            Create_Tween(Picker, 0.22, {Size = UDim2.new(1, -28, 0, Is_Open and Picker_Open_Height or 0)})
            Create_Tween(Row, 0.24, {Size = UDim2.new(1, 0, 0, Is_Open and (46 + Picker_Open_Height + 8) or 46)})
        end

        Swatch.MouseButton1Click:Connect(function()
            Set_Open(not Is_Open)
        end)

        local function Update_SV(Pixel_X, Pixel_Y)
            local Alpha_X = math.clamp((Pixel_X - SV_Box.AbsolutePosition.X) / math.max(SV_Box.AbsoluteSize.X, 1), 0, 1)
            local Alpha_Y = math.clamp((Pixel_Y - SV_Box.AbsolutePosition.Y) / math.max(SV_Box.AbsoluteSize.Y, 1), 0, 1)
            Saturation, Value = Alpha_X, 1 - Alpha_Y
            SV_Target_X, SV_Target_Y = Alpha_X, Alpha_Y
            Recolor(false)
        end

        local function Update_Hue(Pixel_Y)
            local Alpha_Y = math.clamp((Pixel_Y - Hue_Bar.AbsolutePosition.Y) / math.max(Hue_Bar.AbsoluteSize.Y, 1), 0, 1)
            Hue = Alpha_Y
            Hue_Target = Alpha_Y
            Recolor(false)
        end

        local SV_Hit = Create_Instance('TextButton', {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = '',
            ZIndex = 23,
            AutoButtonColor = false,
        }, SV_Box)

        local Hue_Hit = Create_Instance('TextButton', {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = '',
            ZIndex = 23,
            AutoButtonColor = false,
        }, Hue_Bar)

        SV_Hit.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SV_Dragging = true
                Update_SV(Input.Position.X, Input.Position.Y)
            end
        end)

        Hue_Hit.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Hue_Dragging = true
                Update_Hue(Input.Position.Y)
            end
        end)

        Connection['Color_Drag_' .. Flag] = UserInputService.InputChanged:Connect(function(Input)
            if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then return end

            if SV_Dragging then
                Update_SV(Input.Position.X, Input.Position.Y)
            end

            if Hue_Dragging then
                Update_Hue(Input.Position.Y)
            end
        end)

        Connection['Color_End_' .. Flag] = UserInputService.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if SV_Dragging or Hue_Dragging then
                    self:Autosave()
                end
                SV_Dragging, Hue_Dragging = false, false
            end
        end)

        local Smoothing_Active = false
        Connection['Color_Smooth_' .. Flag] = RunService.Heartbeat:Connect(function(Delta_Time)
            local X = SV_Cursor.Position.X.Scale
            local Y = SV_Cursor.Position.Y.Scale
            local Hue_Now = Hue_Cursor.Position.Y.Scale
            local Needs_Update = SV_Dragging or Hue_Dragging
                or math.abs(X - SV_Target_X) > 0.001
                or math.abs(Y - SV_Target_Y) > 0.001
                or math.abs(Hue_Now - Hue_Target) > 0.001
            if not Needs_Update then return end
            local Alpha = 1 - math.exp(-18 * Delta_Time)
            local New_X = X + (SV_Target_X - X) * Alpha
            local New_Y = Y + (SV_Target_Y - Y) * Alpha
            SV_Cursor.Position = UDim2.fromScale(New_X, New_Y)
            local New_Hue = Hue_Now + (Hue_Target - Hue_Now) * Alpha
            Hue_Cursor.Position = UDim2.new(0.5, 0, New_Hue, 0)
        end)

        Hex_Input.FocusLost:Connect(function()
            local Parsed = Hex_To_Color(Hex_Input.Text)
            if Parsed then
                Hue, Saturation, Value = Color3.toHSV(Parsed)
                SV_Target_X, SV_Target_Y = Saturation, 1 - Value
                Hue_Target = Hue
                SV_Cursor.Position = UDim2.fromScale(Saturation, 1 - Value)
                Hue_Cursor.Position = UDim2.new(0.5, 0, Hue, 0)
                Recolor(false)
                self:Autosave()
            else
                Hex_Input.Text = Color_To_Hex(Color3.fromHSV(Hue, Saturation, Value)):gsub('#', '')
            end
        end)

        self.Flags[Flag] = Default
        self.Control_Objects[Flag] = {
            Kind = 'color',
            Apply = function(Value_Argument, Silent)
                local Color = Value_Argument
                if type(Value_Argument) == 'string' then
                    Color = Hex_To_Color(Value_Argument)
                end
                if typeof(Color) == 'Color3' then
                    Hue, Saturation, Value = Color3.toHSV(Color)

                    SV_Target_X, SV_Target_Y = Saturation, 1 - Value
                    Hue_Target = Hue

                    SV_Cursor.Position = UDim2.fromScale(Saturation, 1 - Value)
                    Hue_Cursor.Position = UDim2.new(0.5, 0, Hue, 0)

                    Recolor(Silent)
                end
            end,
        }

        self.Control_Objects[Flag].Apply(Default, true)

        if Options.callback then
            pcall(Options.callback, Default)
        end

        Register_Search(Row, Options.name or Flag)
        return Row
    end

    function Tab.Create_Menu(Options)
        Options = Options or {}
        local Has_Description = Options.info and Options.info ~= ''
        local Header_Height = Has_Description and 46 or 38

        local Menu = Create_Instance('Frame', {
            Name = Options.name or 'Menu',
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Theme_Ref('Panel_2'),
            BorderSizePixel = 0,
            LayoutOrder = Next_Order(Options.section),
            ZIndex = 15,
        }, Target_Column(Options.section))

        Create_Corner(Menu, 8)
        Create_Stroke(Menu, 'Border', 1, 0.5)

        Create_Instance('UIListLayout', {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 0),
        }, Menu)

        local Header = Create_Instance('TextButton', {
            Name = 'Header',
            Size = UDim2.new(1, 0, 0, Header_Height),
            BackgroundTransparency = 1,
            Text = '',
            AutoButtonColor = false,
            LayoutOrder = 1,
            ZIndex = 16,
        }, Menu)

        local Head_Row = Create_Instance('Frame', {
            Position = UDim2.fromOffset(14, Has_Description and 9 or 11),
            Size = UDim2.new(1, -40, 0, 18),
            BackgroundTransparency = 1,
            ZIndex = 17,
        }, Header)

        Create_Instance('UIListLayout', {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 6),
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, Head_Row)

        Create_Instance('TextLabel', {
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, 18),
            BackgroundTransparency = 1,
            FontFace = Font_Ref(Enum.FontWeight.SemiBold),
            TextSize = 14,
            Text = Options.name or 'Menu',
            TextColor3 = Theme_Ref('Text'),
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 1,
            ZIndex = 17,
        }, Head_Row)

        if Options.badge then
            local Badge_Color = Badge_Colors[Options.badge] or Badge_Colors.New
            local Badge_Label = Create_Instance('TextLabel', {
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2.fromOffset(0, 16),
                BackgroundColor3 = Badge_Color.Background,
                FontFace = Font_Ref(Enum.FontWeight.SemiBold),
                TextSize = 10,
                Text = Options.badge,
                TextColor3 = Badge_Color.Text,
                LayoutOrder = 2,
                ZIndex = 17,
            }, Head_Row)
            Create_Instance('UIPadding', {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}, Badge_Label)
            Create_Corner(Badge_Label, 4)
            Create_Instance('UIStroke', {Color = Badge_Color.Border, Thickness = 1, Transparency = 0.5}, Badge_Label)
        end

        if Has_Description then
            Create_Instance('TextLabel', {
                Position = UDim2.fromOffset(14, 28),
                Size = UDim2.fromOffset(300, 14),
                BackgroundTransparency = 1,
                FontFace = Font_Ref(Enum.FontWeight.SemiBold),
                TextSize = 11,
                Text = Options.info or '',
                TextColor3 = Theme_Ref('Dim'),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 17,
            }, Header)
        end

        local Arrow = Create_Instance('ImageLabel', {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0, Header_Height / 2),
            Size = UDim2.fromOffset(14, 14),
            BackgroundTransparency = 1,
            Image = 'rbxassetid://7733717447',
            ImageColor3 = Theme_Ref('Muted'),
            Rotation = -90,
            ZIndex = 17,
        }, Header)

        local Clipper = Create_Instance('Frame', {
            Name = 'Clipper',
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            LayoutOrder = 2,
            ZIndex = 15,
        }, Menu)

        local Body = Create_Instance('Frame', {
            Name = 'Body',
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            ZIndex = 15,
        }, Clipper)

        Create_Instance('UIPadding', {
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 10),
        }, Body)

        Create_Instance('UIListLayout', {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
        }, Body)

        local Container = {Frame = Body, Order = 0}

        local Is_Open = (tostring(Options.default or ''):lower() == 'open') or (Options.opened == true)
        local function Set_Open(State_Open, Instant)
            Is_Open = State_Open

            Create_Tween(Arrow, Instant and 0.001 or 0.20, {Rotation = Is_Open and 0 or -90})

            local Target_Height = Is_Open and Body.AbsoluteSize.Y or 0
            Create_Tween(Clipper, Instant and 0.001 or 0.24, {
                Size = UDim2.new(1, 0, 0, Target_Height),
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

            if Is_Open then
                for _, Descendant in ipairs(Body:GetDescendants()) do
                    if Descendant:GetAttribute('IsDivider') then
                        Descendant:SetAttribute('Replay', tick())
                    end
                end
            end
        end

        Body:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
            if Is_Open then
                Create_Tween(Clipper, 0.16, {
                    Size = UDim2.new(1, 0, 0, Body.AbsoluteSize.Y),
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            end
        end)

        Header.MouseButton1Click:Connect(function()
            Set_Open(not Is_Open, false)
        end)

        task.defer(function()
            Set_Open(Is_Open, true)
        end)

        Register_Search(Menu, Options.name, Options.info, Options.flag)

        local function Wrap(Func)
            return function(Sub_Options)
                Sub_Options = Sub_Options or {}
                Sub_Options.section = Container
                return Func(Sub_Options)
            end
        end

        return {
            Create_Title = Wrap(Tab.Create_Title),
            Create_Label = Wrap(Tab.Create_Label),
            Create_Paragraph = Wrap(Tab.Create_Paragraph),
            Create_Divider = Wrap(Tab.Create_Divider),
            Create_Separator = Wrap(Tab.Create_Separator),
            Create_Image = Wrap(Tab.Create_Image),
            Create_Button = Wrap(Tab.Create_Button),
            Create_Toggle = Wrap(Tab.Create_Toggle),
            Create_Slider = Wrap(Tab.Create_Slider),
            Create_Dropdown = Wrap(Tab.Create_Dropdown),
            Create_Keybind = Wrap(Tab.Create_Keybind),
            Create_Textbox = Wrap(Tab.Create_Textbox),
            Create_Color_Picker = Wrap(Tab.Create_Color_Picker),
            Create_Playerlist = Wrap(Tab.Create_Playerlist),
            Instance = Menu,
            Set_Open = Set_Open,
        }
    end

    return Tab
end

function Library:Get_Flag(Flag)
    return self.Flags[Flag]
end

function Library:Set_Flag(Flag, Value)
    self:Apply_Flag(Flag, Value, false)
    self:Autosave()
end

function Library:Save()
    return Save_Config(self.Active_Config_Name, self.Flags)
end

function Library:Save_As(Name)
    self.Active_Config_Name = Sanitize_File_Name(Name)
    return Save_Config(self.Active_Config_Name, self.Flags)
end

function Library:Load(Name)
    local Loaded = Load_Config(Name)
    if not Loaded then return false end
    self.Active_Config_Name = Sanitize_File_Name(Name)
    self.Loading = true
    for Flag, Value in pairs(Loaded) do
        self:Apply_Flag(Flag, Value, true)
    end
    self.Loading = false
    self:Status('Config loaded: ' .. self.Active_Config_Name, Theme.Success, 1.8)
    return true
end

function Library:Delete_Config(Name)
    return Delete_Config(Name)
end

function Library:List_Configs()
    return List_Configs()
end

function Library:Set_Theme(Name)
    if Library.Themes[Name] then
        Apply_Theme(Library.Themes[Name], Name, false)
        return true
    end
    local Custom = Custom_Themes[Name] or Load_Theme(Name)
    if Custom then
        Custom_Themes[Name] = Custom
        Apply_Theme(Custom, Name, false)
        return true
    end
    return false
end

function Library:Save_Custom_Theme(Name)
    Name = Sanitize_File_Name(Name)
    local Snapshot = {}
    for Key, Value in pairs(Theme) do
        Snapshot[Key] = Value
    end
    Custom_Themes[Name] = Snapshot
    self.Active_Theme_Name = Name
    return Save_Theme(Name, Snapshot)
end

function Library:Delete_Custom_Theme(Name)
    return Delete_Theme(Name)
end

function Library:List_Themes()
    return All_Theme_Names()
end

function Library:Set_Font(Name)
    Apply_Font(Name)
end

function Library:List_Fonts()
    return Font_Family_Order
end

function Library:Attach_Settings_Tab(Icon)
    local Tab = self:Create_Tab('Settings', Icon or '7734053426')

    Tab.Create_Title({name = 'Interface', section = 'left'})

    Tab.Create_Toggle({
        name = 'Freeform Dragging',
        info = 'Allow the panel to leave the screen bounds',
        flag = 'Ancapri_Freedom',
        section = 'left',
        callback = function(Value) self.Freedom_Enabled = Value end,
    })

    Tab.Create_Toggle({
        name = 'Drag Enabled',
        flag = 'Ancapri_Drag_Enabled',
        enabled = true,
        section = 'left',
        callback = function(Value) self.Interface_Drag_Enabled = Value end,
    })

    Tab.Create_Toggle({
        name = 'Dynamic Tab Icons',
        flag = 'Ancapri_Dynamic_Tabs',
        enabled = true,
        section = 'left',
        callback = function(Value) self.Dynamic_Tabs_Enabled = Value end,
    })

    Tab.Create_Dropdown({
        name = 'Tab Icon Animation',
        flag = 'Ancapri_Tab_Anim_Style',
        options = {'Grow', 'Pop', 'Fade', 'Zoom'},
        default = 'Grow',
        section = 'left',
        callback = function(Value) self.Dynamic_Tabs_Animations_Type_Enabled = Value end,
    })

    Tab.Create_Keybind({
        name = 'Toggle Keybind',
        flag = 'Ancapri_Toggle_Key',
        default = self.Interface_Keybind or Enum.KeyCode.N,
        section = 'left',
        callback = function(Value) self.Interface_Keybind = Value end,
    })

    Tab.Create_Slider({
        name = 'Click Volume',
        flag = 'Ancapri_Click_Volume',
        min = 0,
        max = 1,
        step = 0.05,
        decimals = 2,
        default = 1,
        section = 'left',
        callback = function(Value) self.Clicks_Volume_Enabled = Value end,
    })

    Tab.Create_Title({name = 'Window', section = 'left'})

    Tab.Create_Toggle({
        name = 'Auto Resize',
        info = 'Continuously fits the window to your device as the viewport changes',
        flag = 'Ancapri_Auto_Resize',
        enabled = false,
        section = 'left',
        callback = function(Value)
            self.Auto_Resize_Enabled = Value
            if Value then
                self:Auto_Resize(false)
            end
        end,
    })

    Tab.Create_Button({
        name = 'Auto-Fit Now',
        info = 'Calculates the best size for your current device once',
        section = 'left',
        callback = function()
            self:Auto_Resize(false)
        end,
    })

    Tab.Create_Title({name = 'Configuration', section = 'left'})

    Tab.Create_Textbox({
        name = 'Config Name',
        flag = 'Ancapri_Config_Name_Input',
        default = self.Active_Config_Name,
        placeholder = 'Default',
        section = 'left',
    })

    Tab.Create_Dropdown({
        name = 'Saved Configs',
        flag = 'Ancapri_Config_Select',
        options = self:List_Configs(),
        default = self.Active_Config_Name,
        section = 'left',
        callback = function(Value)
            self:Apply_Flag('Ancapri_Config_Name_Input', Value, true)
        end,
    })

    Tab.Create_Button({
        name = 'Save Config',
        info = 'Saves all current flag values under this name',
        section = 'left',
        callback = function()
            local Name = self.Flags['Ancapri_Config_Name_Input']
            if Name and Name ~= '' then
                self:Save_As(Name)
                self:Status('Saved config: ' .. Name, Theme.Success, 1.8)
            end
        end,
    })

    Tab.Create_Button({
        name = 'Load Config',
        info = 'Loads the config typed above',
        section = 'left',
        callback = function()
            local Name = self.Flags['Ancapri_Config_Name_Input']
            if Name and Name ~= '' then
                self:Load(Name)
            end
        end,
    })

    Tab.Create_Button({
        name = 'Delete Config',
        info = 'Deletes the config typed above',
        section = 'left',
        callback = function()
            local Name = self.Flags['Ancapri_Config_Name_Input']
            if Name and Name ~= '' then
                Delete_Config(Name)
                self:Status('Deleted config: ' .. Name, Theme.Warning, 1.8)
            end
        end,
    })

    Tab.Create_Title({name = 'Theme', section = 'right'})

    Tab.Create_Dropdown({
        name = 'Preset',
        flag = 'Ancapri_Theme_Preset',
        options = All_Theme_Names(),
        default = self.Active_Theme_Name,
        section = 'right',
        callback = function(Value)
            self:Set_Theme(Value)
            self:Apply_Flag('Ancapri_Theme_Accent', Theme.Accent, true)
            self:Apply_Flag('Ancapri_Theme_Panel', Theme.Panel, true)
            self:Apply_Flag('Ancapri_Theme_Panel_2', Theme.Panel_2, true)
            self:Apply_Flag('Ancapri_Theme_Text', Theme.Text, true)
        end,
    })

    Tab.Create_Color_Picker({
        name = 'Accent',
        flag = 'Ancapri_Theme_Accent',
        default = Theme.Accent,
        section = 'right',
        callback = function(Value) Apply_Theme({Accent = Value, Accent_Hover = Value}, 'Custom', false) end,
    })

    Tab.Create_Color_Picker({
        name = 'Panel',
        flag = 'Ancapri_Theme_Panel',
        default = Theme.Panel,
        section = 'right',
        callback = function(Value) Apply_Theme({Panel = Value}, 'Custom', false) end,
    })

    Tab.Create_Color_Picker({
        name = 'Panel 2',
        flag = 'Ancapri_Theme_Panel_2',
        default = Theme.Panel_2,
        section = 'right',
        callback = function(Value) Apply_Theme({Panel_2 = Value}, 'Custom', false) end,
    })

    Tab.Create_Color_Picker({
        name = 'Text',
        flag = 'Ancapri_Theme_Text',
        default = Theme.Text,
        section = 'right',
        callback = function(Value) Apply_Theme({Text = Value}, 'Custom', false) end,
    })

    Tab.Create_Textbox({
        name = 'Theme Name',
        flag = 'Ancapri_Theme_Save_Name',
        placeholder = 'My Theme',
        section = 'right',
    })

    Tab.Create_Button({
        name = 'Save Theme',
        section = 'right',
        callback = function()
            local Name = self.Flags['Ancapri_Theme_Save_Name']
            if Name and Name ~= '' then
                self:Save_Custom_Theme(Name)
                self:Status('Theme saved: ' .. Name, Theme.Success, 1.8)
            end
        end,
    })

    Tab.Create_Button({
        name = 'Reset Theme',
        info = 'Restores the built-in Crimson theme',
        section = 'right',
        callback = function()
            self:Set_Theme('Crimson')
            self:Apply_Flag('Ancapri_Theme_Preset', 'Crimson', true)
            self:Apply_Flag('Ancapri_Theme_Accent', Theme.Accent, true)
            self:Apply_Flag('Ancapri_Theme_Panel', Theme.Panel, true)
            self:Apply_Flag('Ancapri_Theme_Panel_2', Theme.Panel_2, true)
            self:Apply_Flag('Ancapri_Theme_Text', Theme.Text, true)
        end,
    })

    Tab.Create_Title({name = 'Font', section = 'right'})

    Tab.Create_Dropdown({
        name = 'Font Family',
        flag = 'Ancapri_Font_Family',
        options = Font_Family_Order,
        default = self.Active_Font_Name,
        section = 'right',
        callback = function(Value) self:Set_Font(Value) end,
    })

    Tab.Create_Title({name = 'Notifications', section = 'right'})

    Tab.Create_Dropdown({
        name = 'Position',
        flag = 'Ancapri_Notify_Position',
        options = Notify_Position_Order,
        default = self.Notify_Position,
        section = 'right',
        callback = function(Value) self.Notify_Position = Value end,
    })

    Tab.Create_Dropdown({
        name = 'Sound',
        flag = 'Ancapri_Notify_Sound',
        options = Notify_Sound_Order,
        default = self.Notify_Sound,
        section = 'right',
        callback = function(Value) self.Notify_Sound = Value end,
    })

    Tab.Create_Slider({
        name = 'Notify Volume',
        flag = 'Ancapri_Notify_Volume',
        min = 0,
        max = 1,
        step = 0.05,
        decimals = 2,
        default = self.Notify_Volume,
        section = 'right',
        callback = function(Value) self.Notify_Volume = Value end,
    })

    Tab.Create_Toggle({
        name = 'Translate Notifications',
        flag = 'Ancapri_Notify_Translate',
        section = 'right',
        callback = function(Value) self.Notify_Translate_Enabled = Value end,
    })

    Tab.Create_Dropdown({
        name = 'Translate Language',
        flag = 'Ancapri_Notify_Language',
        options = Language_Order,
        default = 'English',
        section = 'right',
        callback = function(Value) self.Notify_Translate_Language = Value end,
    })

    Tab.Create_Button({
        name = 'Test Notification',
        section = 'right',
        callback = function()
            self:Notify({
                Title = 'Ancapri',
                Description = 'This is a test notification.',
                Kind = 'Info',
                Duration = 4,
            })
        end,
    })

    return Tab
end

function Library.Show_Loading_Screen(Options)
    Options = Options or {}

    if Options.Theme then
        local Theme_Data = Library.Themes[Options.Theme] or Custom_Themes[Options.Theme] or Load_Theme(Options.Theme)
        if Theme_Data then
            Apply_Theme(Theme_Data, Options.Theme, true)
        end
    end

    if Options.Font and Font_Families[Options.Font] then
        Apply_Font(Options.Font)
    end

    local Steps = Options.Steps or {'Initializing Interface.', 'Capturing Game.', 'Finalizing UI.'}
    local Step_Duration = Options.Step_Duration or 1.3
    local Hold_Duration = Options.Hold_Duration or 0.7
    local Auto_Destroy = Options.Auto_Destroy
    if Auto_Destroy == nil then Auto_Destroy = true end
    local On_Complete = Options.On_Complete
    local Title_Text = Options.Title or ((getgenv and getgenv().Product_Name) or 'Ancapri')

    local Existing = CoreGui:FindFirstChild('Ancapri_Loading')
    if Existing then Existing:Destroy() end

    local Screen_Gui = Create_Instance('ScreenGui', {
        Name = 'Ancapri_Loading',
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        DisplayOrder = 998,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, CoreGui)

    local Base_Width, Base_Height = 900, 430

    local Panel = Create_Instance('CanvasGroup', {
        Name = 'Panel',
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(Base_Width, Base_Height),
        BackgroundColor3 = Theme_Ref('Panel'),
        BorderSizePixel = 0,
        GroupTransparency = 1,
        ZIndex = 10,
    }, Screen_Gui)

    local Fit_Scale = Create_Instance('UIScale', {
        Scale = 1,
    }, Panel)

    local function Compute_Fit_Scale()
        local Viewport = Screen_Gui.AbsoluteSize
        local Available_Width, Available_Height

        if Device['Mobile'] then
            Available_Width = Viewport.X * 0.92
            Available_Height = Viewport.Y * 0.56
        else
            Available_Width = Viewport.X * 0.6
            Available_Height = Viewport.Y * 0.6
        end

        local Scale = math.min(Available_Width / Base_Width, Available_Height / Base_Height)
        Scale = math.clamp(Scale, 0.42, 1)
        return math.floor(Scale * 20 + 0.5) / 20
    end

    local function Update_Fit_Scale(Instant)
        local Target_Scale = Compute_Fit_Scale()
        if Instant then
            Fit_Scale.Scale = Target_Scale
        else
            Create_Tween(Fit_Scale, 0.3, {Scale = Target_Scale}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end
    end

    Update_Fit_Scale(true)

    Screen_Gui:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
        Update_Fit_Scale(false)
    end)

    Create_Corner(Panel, 16)
    Create_Stroke(Panel, 'Border', 1, 0.5)

    Create_Instance('TextLabel', {
        Position = UDim2.fromOffset(30, 24),
        Size = UDim2.fromOffset(320, 32),
        BackgroundTransparency = 1,
        FontFace = Font_Ref(Enum.FontWeight.SemiBold),
        TextSize = 24,
        Text = Title_Text .. '.',
        TextColor3 = Theme_Ref('Accent'),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 11,
    }, Panel)

    local Time_Pill = Create_Instance('Frame', {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -30, 0, 26),
        Size = UDim2.fromOffset(0, 32),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Theme_Ref('Panel_2'),
        BorderSizePixel = 0,
        ZIndex = 11,
    }, Panel)

    Create_Corner(Time_Pill, 8)
    Create_Stroke(Time_Pill, 'Border', 1, 0.5)
    Create_Instance('UIPadding', {PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14)}, Time_Pill)

    local Time_Label = Create_Instance('TextLabel', {
        Size = UDim2.fromOffset(0, 32),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Font = Enum.Font.Code,
        TextSize = 14,
        Text = '',
        TextColor3 = Theme_Ref('Text'),
        ZIndex = 12,
    }, Time_Pill)

    local Status_Container = Create_Instance('Frame', {
        Position = UDim2.fromOffset(30, 78),
        Size = UDim2.fromOffset(460, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 11,
    }, Panel)

    Create_Instance('UIListLayout', {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, Status_Container)

    local Warper = Create_Instance('Frame', {
        Name = 'Warper',
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.62, 0, 0.46, 0),
        Size = UDim2.fromOffset(170, 136),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 11,
    }, Panel)

    local Animated = Create_Instance('ImageLabel', {
        Size = UDim2.new(3, 0, 3, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = 'rbxassetid://133009150415671',
        ImageTransparency = 1,
        ZIndex = 12,
    }, Warper)

    Create_Tween(Animated, 0.6, {ImageTransparency = 0})

    local Elapsed_Label = Create_Instance('TextLabel', {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 30, 1, -110),
        Size = UDim2.fromOffset(120, 20),
        BackgroundTransparency = 1,
        Font = Enum.Font.Code,
        TextSize = 14,
        Text = '00:00',
        TextColor3 = Theme_Ref('Muted'),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 11,
    }, Panel)

    local Percent_Label = Create_Instance('TextLabel', {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -30, 1, -110),
        Size = UDim2.fromOffset(70, 20),
        BackgroundTransparency = 1,
        Font = Enum.Font.Code,
        TextSize = 14,
        Text = '0%',
        TextColor3 = Theme_Ref('Text'),
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 11,
    }, Panel)

    local Bar_Track = Create_Instance('Frame', {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 30, 1, -86),
        Size = UDim2.new(1, -60, 0, 6),
        BackgroundColor3 = Theme_Ref('Not_Enabled'),
        BorderSizePixel = 0,
        ZIndex = 11,
    }, Panel)

    Create_Corner(Bar_Track, 3)

    local Bar_Fill = Create_Instance('Frame', {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme_Ref('Accent'),
        BorderSizePixel = 0,
        ZIndex = 12,
    }, Bar_Track)

    Create_Corner(Bar_Fill, 3)

    Create_Instance('Frame', {
        Name = 'Divider',
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 30, 1, -40),
        Size = UDim2.new(1, -60, 0, 1),
        BackgroundColor3 = Theme_Ref('Border'),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 11,
    }, Panel)

    local Bottom_Dot = Create_Instance('Frame', {
        Name = 'Dot',
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -16),
        Size = UDim2.fromOffset(4, 4),
        BackgroundColor3 = Theme_Ref('Dim'),
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        ZIndex = 11,
    }, Panel)

    Create_Corner(Bottom_Dot, 2)

    local Progress_Value = Create_Instance('NumberValue', {
        Value = 0,
    }, Screen_Gui)

    Progress_Value.Changed:Connect(function(Value)
        local Clamped = math.clamp(Value, 0, 1)
        Bar_Fill.Size = UDim2.new(Clamped, 0, 1, 0)
        Percent_Label.Text = tostring(math.floor(Clamped * 100)) .. '%'
    end)

    local function Create_Status_Row(Order)
        local Row = Create_Instance('Frame', {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            LayoutOrder = Order,
            ZIndex = 12,
        }, Status_Container)

        Create_Instance('UIListLayout', {
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center,
        }, Row)

        local Prefix_Label = Create_Instance('TextLabel', {
            Size = UDim2.fromOffset(18, 20),
            BackgroundTransparency = 1,
            Font = Enum.Font.Code,
            TextSize = 15,
            Text = '>',
            TextColor3 = Theme_Ref('Dim'),
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 1,
            ZIndex = 13,
        }, Row)

        local Text_Label = Create_Instance('TextLabel', {
            Size = UDim2.fromOffset(0, 20),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Font = Enum.Font.Code,
            TextSize = 15,
            Text = '',
            TextColor3 = Theme_Ref('Muted'),
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 2,
            ZIndex = 13,
        }, Row)

        local Dots_Label = Create_Instance('TextLabel', {
            Size = UDim2.fromOffset(26, 20),
            BackgroundTransparency = 1,
            Font = Enum.Font.Code,
            TextSize = 15,
            Text = '',
            TextColor3 = Theme_Ref('Dim'),
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 3,
            ZIndex = 13,
        }, Row)

        return {Row = Row, Prefix = Prefix_Label, Text = Text_Label, Dots = Dots_Label}
    end

    local function Type_Text(Label, Full_Text)
        Label.Text = ''
        for Index = 1, #Full_Text do
            Label.Text = Full_Text:sub(1, Index)
            task.wait(0.028)
        end
    end

    local function Run_Dots(Label, Duration)
        local Patterns = {'', '.', '..', '...'}
        local Start_Time = tick()
        local Pattern_Index = 1
        while tick() - Start_Time < Duration do
            Label.Text = Patterns[Pattern_Index]
            Pattern_Index = (Pattern_Index % #Patterns) + 1
            task.wait(0.24)
        end
        Label.Text = ''
    end

    local function Complete_Row(Row_Data)
        Create_Tween(Row_Data.Prefix, 0.14, {TextTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        task.wait(0.14)
        Row_Data.Prefix.Text = '✓'
        Row_Data.Prefix.TextColor3 = Theme.Success
        Row_Data.Prefix.TextTransparency = 1
        Create_Tween(Row_Data.Prefix, 0.26, {TextTransparency = 0}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        Create_Tween(Row_Data.Text, 0.26, {TextColor3 = Theme.Text})
        task.wait(0.26)
    end

    local Start_Tick = os.clock()

    task.spawn(function()
        while Screen_Gui and Screen_Gui.Parent do
            local Elapsed = math.floor(os.clock() - Start_Tick)
            local Minutes = math.floor(Elapsed / 60)
            local Seconds = Elapsed % 60
            Elapsed_Label.Text = string.format('%02d:%02d', Minutes, Seconds)

            local Now = os.date('*t')
            local Hour = Now.hour % 12
            if Hour == 0 then Hour = 12 end
            Time_Label.Text = string.format('%02d:%02d %s   ·   %ds', Hour, Now.min, Now.hour >= 12 and 'PM' or 'AM', Elapsed)

            task.wait(1)
        end
    end)

    task.spawn(function()
        local Frame_Rate = 12
        local Current_Frame = 1
        local Total_Frames = 8
        local Column_Count = 3
        local Last_Time = tick()
        while Animated and Animated.Parent do
            local Real_Time = tick()
            if Real_Time - Last_Time >= 1 / Frame_Rate then
                Current_Frame = (Current_Frame % Total_Frames) + 1
                local Current_Column = ((Current_Frame - 1) % Column_Count) + 1
                local Current_Row = math.floor((Current_Frame - 1) / Column_Count) + 1
                Animated.Position = UDim2.new(-(Current_Column - 1), 0, -(Current_Row - 1), 0)
                Last_Time = Real_Time
            end
            RunService.Heartbeat:Wait()
        end
    end)

    task.spawn(function()
        task.wait(0.05)
        Create_Tween(Panel, 0.35, {GroupTransparency = 0})
        task.wait(0.4)

        local Total_Steps = math.max(#Steps, 1)

        for Index, Step_Text in ipairs(Steps) do
            local Row_Data = Create_Status_Row(Index)
            Type_Text(Row_Data.Text, Step_Text)
            Create_Tween(Progress_Value, Step_Duration, {Value = Index / Total_Steps}, Enum.EasingStyle.Linear)
            Run_Dots(Row_Data.Dots, Step_Duration)
            Complete_Row(Row_Data)
        end

        task.wait(Hold_Duration)

        if On_Complete then
            pcall(On_Complete)
        end

        if Auto_Destroy then
            Create_Tween(Panel, 0.35, {GroupTransparency = 1})
            task.wait(0.4)
            if Screen_Gui then
                Screen_Gui:Destroy()
                Screen_Gui = nil
            end
        end
    end)

    local Controller = {}

    function Controller.Destroy()
        if Screen_Gui then
            Screen_Gui:Destroy()
            Screen_Gui = nil
        end
    end

    return Controller
end

return Library
