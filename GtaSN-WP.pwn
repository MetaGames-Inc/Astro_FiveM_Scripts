// File: weapon_manager.pwn

#include <a_samp>
#include <weapon_data>

#define MAX_WEAPONS 50
#define MAX_COMPONENTS 5

new g_WeaponData[MAX_WEAPONS];
new g_WeaponComponents[MAX_WEAPONS][MAX_COMPONENTS];
new g_WeaponCount;

enum WeaponTypes
{
    WEAPON_PISTOL,
    WEAPON_SMG,
    // Aggiungi altri tipi di armi se necessario
}

enum WeaponComponents
{
    COMP_SCOPE,
    COMP_SUPPRESSOR,
    // Aggiungi altri componenti se necessario
}

public OnGameModeInit()
{
    g_WeaponCount = 0;
}

public AddWeapon(weaponid, name[], weight)
{
    if(g_WeaponCount >= MAX_WEAPONS)
        return INVALID_WEAPON_ID;

    new weaponIndex = g_WeaponCount++;
    g_WeaponData[weaponIndex][weapon_id] = weaponid;
    g_WeaponData[weaponIndex][weapon_name] = name;
    g_WeaponData[weaponIndex][weapon_weight] = weight;
    g_WeaponData[weaponIndex][weapon_components] = 0;
    return weaponIndex;
}

public AddWeaponComponent(weaponIndex, component)
{
    if(g_WeaponData[weaponIndex][weapon_components] >= MAX_COMPONENTS)
        return INVALID_COMPONENT;

    new componentIndex = g_WeaponData[weaponIndex][weapon_components]++;
    g_WeaponComponents[weaponIndex][componentIndex] = component;
    return componentIndex;
}

public GetWeaponName(weaponIndex)
{
    return g_WeaponData[weaponIndex][weapon_name];
}

public GetWeaponWeight(weaponIndex)
{
    return g_WeaponData[weaponIndex][weapon_weight];
}

public GetWeaponComponents(weaponIndex, &components[])
{
    for(new i = 0; i < g_WeaponData[weaponIndex][weapon_components]; i++)
    {
        components[i] = g_WeaponComponents[weaponIndex][i];
    }
}

// Altre funzioni di gestione delle armi possono essere aggiunte qui