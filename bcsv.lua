-- Networking
RegisterServerEvent("netDisable")
AddEventHandler("netDiable", function(bcnetid, target)
    TriggerClientEvent('disableBaitCar', target, bcnetid)
end)

RegisterServerEvent("netUnlock")
AddEventHandler("netUnlock", function(bcnetid, target)
    TriggerClientEvent('unlockBaitCar', target, bcnetid)
end)

RegisterServerEvent("netRearm")
AddEventHandler("netRearm", function(bcnetid, target)
    TriggerClientEvent('rearmBaitCar', target, bcnetid)
end)

RegisterServerEvent("netReset")
AddEventHandler("netReset", function(bcnetid, target)
    TriggerClientEvent('resetBaitCar', -1)
end)

--- Permission Checked
RegisterServerEvent("TragicBaitcar.getIsAllowed")
AddEventHandler("TragicBaitcar.getIsAllowed", function()
    if IsPlayerAceAllowed(source, "TragicBaitCar.open_menu") then
        TriggerClientEvent("TragicBaitcar.returnIsAllowed", source, true)
    else
        TriggerClientEvent("TragicBaitcar.retutnIsAllowed", source, false)
    end 
end)

---Version Checker
local versionCheckEnabled = false

-- Branding!
local label =
[[ 
  //(◑‿◐)                                                            (◑‿◐)
  ||  (◑‿◐)                                                         (◑‿◐)
  ||    (◑‿◐)                    Created by TragicMagic          (◑‿◐)
  ||     (◑‿◐)                    Magic Development             (◑‿◐)
  ||]]
