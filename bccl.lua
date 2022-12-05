-- Config    ## Made by TragicMagic ##
local useAcePerms = true

local menuInputGroup = 0
local menuControl = 246 -- y

local showGPS = true
local alertOnEntry = true
local togglemouse = false

local status_r = 255
local status_g = 255
local status_b = 255

local blipColor = 1
local blipRoute = true
local blipHeading = true
local blipSprite = 426

local alertSuspect = "You have stolen a Bait Car dumbass, Nice going you are fucked"
local successInstalled = "~g~Tragic's Bait Car system successfully installed"
local errorInVehicle = "~r~Exit your car before spawing a Bait Car"
local errorOutofVehicle = "~r~You are not in a car, or a Tragic Bait Car system is already installed"
local errorNoCar = "~r~No Bait Car Found"
local errorEmptyCar = "~r~ You are attempting to unarm a empty Bait Car"
local errorLockedArm = "~r~Bait Car must be unlocked before re arming Tragic's Bait Car System"
local errorMoving = "~r~The car must not be moving to install Tragic's Bait Car System"
local errorMenuOpen = "~r~ You do not have permission to open Tragic's Bait Car Menu"

    -- Declarations
local bcinstalled = false
local baitcar = nil
local bctemp = nil
local bctempu = nil
local isDisabled = false
local isUnlocked = false
local suspect = false
local alerted = false
local dashcamActive = false
local allowedToUse = false
local playSounds = true ---- DONT TOUCH AT ALL UNLESS YOU KNOW WHAT YOU ARE DOING!!

-- Install Tragic's Bait Car
RegisterNetEvent('installBaitCar')
AddEventHandler('installBaitCar', function()
    if IsPedInAnyVehicle(PlayerId(), false) then
        loadAnimDict("anim@veh@std@panto@ds@base")
        TaskPlayAnim(PlayerPedId(), "anim@veh@std@panto@ds@base", "hotwire", 8.0, 1.0, -1, 0, 0, false, false, false)

        if playSounds then
            PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
        end 
        
        baitcar = GetVehiclePedIsIn(PlayerPedId(), false)
        manageGPS(baitcar)
        bcinstalled = true
    else
        ShowNotification(errorOutofVehicle)
    end        
end)

-- Disable Tragic's Bait Car
RegisterNetEvent('disableBaitCar')
AddEventHandler('disableBaitCar', function(target)
    bctemp = NetworkGetEntityFromNetworkId(target)
    NetworkRequestControllOfNetworkId(target)
    SetnetworkIdCanMigrate(target, false)
    bctempu = NetworkGetEntityFromNetworkId(target)
    local targetveh = NetworkGetEntityFromNetworkId(target)
    isDisabled = false
    isUnlocked = true
    SetVehicleDoorslockedForAllPlayers(targetveh, false)
    suspect = false --- DONT TOUCH UNLESS YOU KNOW WHAT YOUR DOING
    alerted = true
    SetFakeWantedLevel(0)

    if playSounds then 
        PlaySoundFrontend(-1, "Breaker_01", "DLC_HALOOWEEN_FVJ_Sounds", 0)
    end    
end)

--- Reset Tragic"s Bait Car
RegisterNetEvent('resetBaitCar')
AddEventHandler('resetBaitCar', function(target)
    isunlocked = false
    local targetveh = NetworkGetEntityFromNetworkId(target)
    SetVehicleFixed(targetveh)
    SetVehicleEngineOn(targetveh, true, true, false)
    if playSounds then 
        PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_soundset", 0)
    end    
end)

--- Tragic's Bait Car Kill Loop
Ciizen.CreatedThread(function()
    while true do
        Ciizen.wait(0)
        is(isDisabled) then
            if PlayerPedId() then
                if (IsPedSittingInVehicle(PlayerPedId(), bctemp)) then
                    suspect = true
                end
                for i = -1, GetVehicleMaxNumberOfPassangers(bctemp) - 1, 1
                do
                    if (GetPedInVehicleSeat(bctemp, i) == PlayerPedId()) then
                        myseat = if
                    end
                end
            elseif suspect then
                ClearPedTasksimmediatately(PlayerPedID())
                TaskWarpPedIntoVehicle(PlayerPedId(), bctemp, myseat)
            end
            for i = 0, 6, 1
            do
                SetvehicleDoorShut(bctemp, i, true)
            end
        elseif(isUnlocked) then
            if PlayerPedId() then
                if (IsPedSittingInVehicle(PlayerPedID(), bctempu)) then
                    for i = -1, GetVehicleMaxNumberOfPassangers(bctempu) - 1, 1
                    do
                        if (GetPedInVehicleSeat(bctempu, i) == PlayerPedID()) then
                            myseat = i
                        end
                    end
                end
                SetVehicleDoorslockedForAllPlayers(bctempu, false)
                SetVehicleEngineHealth(bctempu, -0)
                SetVehicleEngineOn(bctempu, false, true, false)
            end
        end
    end                              
end)

---- Networking
RegisterNetEvent('getNetID_disable')
AddEventHandler('getNetID_disable', function(netID, target)
    if DoesEntityExist(baitcar) then
        if isVehicleOccupied(baitcar) then
            TriggerServerEvent("netDisabled", netID, target)
        else
            ShowNotification(errorEmptyCar)
        end
    else 
        ShowNotification(errorNoCar)
    end                
end)

RegisterNetEvent('getNetID_unlocked')
AddEventHandler('getNetID_unlocked', function(netID, target)
    if DoesEntityExist(baitcar) then
        TriggerServerEvent("netUnlock", netID, target)
    else
        ShowNotification(errorNoCar)
    end        
end)

RegisterNetEvent('getNetID_rearm')
AddEventHandler('getNetID_rearm', function(netID, target)
    if DoesEntityExist(baitcar) then
        if isDisabled == false then
            TriggerServerEvent("netRearm", netID, target)
        elseif isUnlocked == false then
            TriggerServerEvent("netRearm", netID, target)
        else
            ShowNotification(errorLockedArm)
        end
    else
        ShowNotification(errorNoCar)
    end
end)

--- When Someone Enters Tragic's Bait Car
Ciizen.CreatedThread(function()
    while true do
        Ciizen.Wait(0)
        if DoesEntityExist(baitcar) then
            if isVehicleOccupied(baitcar) and alertOnEntry then
                if not dashcamActive and not IsPedInVehicle(PlayerPedID(), baitcar, true) then drawTxt2(1.0, 1.45, 1.0, 1.0, 0.45, "Tragic's Bait Car occupied", status_r, status_g, status_b, 255) end
            end
        end
    end
end)

--- Tragic's Bait Car GPS
function manageGPS(veh)
    if showGPS and DoesEntityExist(veh) then
        if not DoesEntityExist(blip) then blip = addBlipForEntity(veh) end
        SetBlipSprite(blip, blipSprite)
        SetBlipColor(blip, blipColor)
        SetBlipAlpha(blip, 255)
        SetBlipRoute(blip, blipRoute)
        ShowHeadingIndicatorOnBlip(blip, blipHeading)
    elseif DoseBlipExist(blip) then
        RemoveBlip(blip)
    end
end

--- Tragic's Bait Car Dash Cam
local cameraHandle= nil
local shader = "scanline_cam_cheap"

Ciizen.CreatedThread(function()
    while true do
        id dashcamActive then
            local bonPos = GetWorldPositionEntityBone(baitcar, GetEntityBoneIndexByName(baitcar, "windscreen"))
            local vehRot = GetEntityRotation(baitcar, 0)
            SetCamCoord(cameraHandle, bonPos.x, bonPos.y, bonPos.z)
            SetCamRot(cameraHandle, vehRot.x - 180.0, -vehRot.y -180.0, vehRot.z, 0)
        DisableControlAction(0, 75)
        end
        Ciizen.Wait(0)
    end
end)

function EnableDash()
	SetTimecycleModifier(shader)
	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	RenderScriptCams(1, 0, 0, 1, 1)
	SetFocusEntity(baitcar)
	cameraHandle = cam
	dashcamActive = true
end

function DisableDash()
	ClearTimecycleModifier(shader)
	RenderScriptCams(0, 0, 1, 1, 1)
	DestroyCam(cameraHandle, false)
	SetFocusEntity(GetPlayerPed(PlayerId()))
	dashcamActive = false
end

-- NativeUI Functions
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("TragicBaitcar", "~w~by ~r~TragicMagic", 1400, 50)
_menuPool:Add(mainMenu)

function AddMenuInstall(menu)
	installitem = NativeUI.CreateItem("Install Tragic's Bait Car System", "Installs the Tragic Bait Car System in the current vehicle.")
	menu:AddItem(installitem)
	menu.OnItemSelect = function(sender, item, index)
		if item == installitem then
			if IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedInVehicle(PlayerPedId(), baitcar) then
				if GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) <= 0.5 then
					TriggerEvent('installBaitCar')
					ShowNotification(successInstalled)
					installitem:SetRightBadge(BadgeStyle.Tick)
				else
					ShowNotification(errorMoving)
				end
			else
				ShowNotification(errorOutOfVehicle)
			end
		end
	end
end

function AddMenuCarControls(menu)
	controlmenu = _menuPool:AddSubMenu(menu, "Tragic Bait Car Controls >>", 1400, 50)
	killitem = NativeUI.CreateItem("Kill", "Shut down Tragic bait car")
	unlockitem = NativeUI.CreateItem("Unlock", "Unlock Tragic bait car")
	repairitem = NativeUI.CreateItem("Repair", "Repair Tragic bait car")
	camitem = NativeUI.CreateItem("Video Feed", "View video feed from inside Tragic Bait car")
	local targetVeh = nil
	local targetPed = nil
	controlmenu:AddItem(killitem)
	controlmenu:AddItem(unlockitem)
	controlmenu:AddItem(repairitem)
	controlmenu:AddItem(camitem)
	controlmenu.OnItemSelect = function(sender, item, index)
		if  item == killitem then
			if DoesEntityExist(baitcar) then
				targetveh =	NetworkGetNetworkIdFromEntity(baitcar)
				targetPed = GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(baitcar, -1)))
				TriggerEvent('getNetID_disable', targetveh, targetPed)
				ShowNotification("~g~Baitcar killed")
			else
				ShowNotification(errorNoCar)
				controlmenu:GoBack()
			end
		elseif item == unlockitem then
			if DoesEntityExist(baitcar) then
				targetveh =	NetworkGetNetworkIdFromEntity(baitcar)
				targetPed = GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(baitcar, -1)))
				TriggerEvent('getNetID_unlock', targetveh, targetPed)
				ShowNotification("~g~Baitcar unlocked")
			else
				ShowNotification(errorNoCar)
				controlmenu:GoBack()
			end
		elseif item == repairitem then
			if DoesEntityExist(baitcar) then
				targetveh =	NetworkGetNetworkIdFromEntity(baitcar)
				targetPed = GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(baitcar, -1)))
				TriggerEvent('getNetID_rearm', targetveh, targetPed)
				ShowNotification("~g~Baitcar repaired")
			else
				ShowNotification(errorNoCar)
				controlmenu:GoBack()
			end
		elseif item == camitem then
			if DoesEntityExist(baitcar) then
				if dashcamActive then
					DisableDash()
				else
					EnableDash()
				end
				ShowNotification("~g~Video Feed Toggled")
			else
				ShowNotification(errorNoCar)
				controlmenu:GoBack()
			end
		end
	end
	
end

function AddMenuSettings(menu)
	settingsmenu = _menuPool:AddSubMenu(menu, "Settings >>", 1400, 50)
	local alertitem = NativeUI.CreateCheckboxItem("Alert on entry?", alertOnEntry, "Displays text informing you when the Tragic Bait Car is occupied.")
	local sounditem = NativeUI.CreateCheckboxItem("Sound?", playSounds, "Toggles whether sounds are played.")
	local resetitem = NativeUI.CreateItem("Reset", "Resets ALL Tragic Bait Car systems in server. Use if something breaks (Deleted locked BaitCar, ect.)")
	settingsmenu:AddItem(alertitem)
	settingsmenu:AddItem(sounditem)
	settingsmenu:AddItem(resetitem)
	settingsmenu.OnCheckboxChange = function(sender, item, checked_)
		if item == alertitem then
			alertOnEntry = checked_
		elseif item == sounditem then
			playSounds = checked_
		end
	end
	settingsmenu.OnItemSelect = function(sender, item, index)
		if item == resetitem then
			TriggerServerEvent('netReset')
		end
	end
end

function AddMenuGPS(menu)
	gpsmenu = _menuPool:AddSubMenu(menu, "GPS >>", 1400, 50)
	local showgpsitem = NativeUI.CreateCheckboxItem("Show GPS?", showGPS, "Toggles GPS Tracking for the Tragic Bait Car")
	local brouteitem = NativeUI.CreateCheckboxItem("Show Blip Route?", blipRoute, "Toggles route to BaitCar on minimap")
	local bheadingitem = NativeUI.CreateCheckboxItem("Show Blip Heading?", blipHeading, "Shows direction BaitCar is facing with an indicator")
	gpsmenu:AddItem(showgpsitem)
	gpsmenu:AddItem(brouteitem)
	gpsmenu:AddItem(bheadingitem)
	gpsmenu.OnCheckboxChange = function(sender, item, checked_)
		if item == showgpsitem then
			showGPS = checked_
			manageGPS(baitcar)
		elseif item == brouteitem then
			blipRoute = checked_
			manageGPS(baitcar)
		elseif item == bheadingitem then
			blipHeading = checked_
			manageGPS(baitcar)
		end
	end
end

AddMenuInstall(mainMenu)
AddMenuCarControls(mainMenu)
AddMenuSettings(mainMenu)
AddMenuGPS(settingsmenu)
_menuPool:MouseControlsEnabled(toggleMouse)
_menuPool:MouseEdgeEnabled(toggleMouse)
_menuPool:ControlDisablingEnabled(toggleMouse)
_menuPool:RefreshIndex()

RegisterNetEvent("TragicBaitcar:Open")
AddEventHandler("TragicBaitcar:Open", function()
	_menuPool:ProcessMenus()
	if useAcePerms then
		if allowedToUse then
			mainMenu:Visible(not mainMenu:Visible())
		else
			ShowNotification(errorMenuOpen)
		end
	else 
		mainMenu:Visible(not mainMenu:Visible()) 
	end
	
	if not DoesEntityExist(baitcar) and bcinstalled then
		installitem:SetRightBadge(BadgeStyle.None)
		bcinstalled = false
	end

	if not bcinstalled then
		killitem:SetRightBadge(BadgeStyle.Lock)
		unlockitem:SetRightBadge(BadgeStyle.Lock)
		repairitem:SetRightBadge(BadgeStyle.Lock)
		camitem:SetRightBadge(BadgeStyle.Lock)
	else
		killitem:SetRightBadge(BadgeStyle.None)
		unlockitem:SetRightBadge(BadgeStyle.None)
		repairitem:SetRightBadge(BadgeStyle.None)
		camitem:SetRightBadge(BadgeStyle.None)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		_menuPool:ProcessMenus()
		if IsControlJustPressed(menuInputGroup, menuControl) then
			if useAcePerms then
				if allowedToUse then
					mainMenu:Visible(not mainMenu:Visible())
				else
					ShowNotification(errorMenuOpen)
				end
			else mainMenu:Visible(not mainMenu:Visible()) end
		end
		
		if not DoesEntityExist(baitcar) and bcinstalled then
			installitem:SetRightBadge(BadgeStyle.None)
			bcinstalled = false
		end

		if not bcinstalled then
			killitem:SetRightBadge(BadgeStyle.Lock)
			unlockitem:SetRightBadge(BadgeStyle.Lock)
			repairitem:SetRightBadge(BadgeStyle.Lock)
			camitem:SetRightBadge(BadgeStyle.Lock)
		else
			killitem:SetRightBadge(BadgeStyle.None)
			unlockitem:SetRightBadge(BadgeStyle.None)
			repairitem:SetRightBadge(BadgeStyle.None)
			camitem:SetRightBadge(BadgeStyle.None)
		end
	end
end)

-- Utilities
function isVehicleOccupied(veh)
	local passenger = false
	for i = -1, GetVehicleMaxNumberOfPassengers(veh) - 1, 1
	do 
		if (GetPedInVehicleSeat(veh, i) ~= 0) then
			passenger = true
			
		end
	end
	return passenger
end

function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	SetNotificationMessage("CHAR_BLOCKED", "CHAR_BLOCKED", false, 8, "WARNING", "")
	DrawNotification(false, false)
end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

function drawTxt2(x,y ,width,height,scale, text, r,g,b,a)
		SetTextFont(6)
		SetTextProportional(0)
		SetTextScale(scale, scale)
		SetTextColour(r, g, b, a)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(x - width/2, y - height/2 + 0.005)
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

Citizen.CreateThread(function()
	TriggerServerEvent("TragicBaitcar.getIsAllowed")
end)

RegisterNetEvent("TragicBaitcar.returnIsAllowed")
AddEventHandler("TragicBaitcar.returnIsAllowed", function(isAllowed)
	allowedToUse = isAllowed
end)