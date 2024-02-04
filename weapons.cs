using System;
using CitizenFX.Core;
using CitizenFX.Core.Native;

public class CustomWeapons : BaseScript
{
    public CustomWeapons()
    {
        EventHandlers["onResourceStart"] += new Action<string>(OnResourceStart);
    }

    private void OnResourceStart(string resourceName)
    {
        if (API.GetCurrentResourceName() != resourceName) return;

        AddSniperRifle();
    }

    private void AddSniperRifle()
    {
        uint sniperRifleHash = (uint)API.GetHashKey("weapon_sniperrifle");

        // Aggiungi il fucile di precisione al giocatore con 100 colpi di munizioni
        API.GiveWeaponToPed(API.PlayerPedId(), sniperRifleHash, 100, false, true);
    }
}