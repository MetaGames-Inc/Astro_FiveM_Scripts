dnxnxn// File: camera_manager.pwn

#include <a_samp>
#include <camera_effects>

#define MAX_CAMERAS 10

new g_CameraData[MAX_CAMERAS][4]; // [handleId][x, y, z, fog_density]
new g_CameraCount;

public OnGameModeInit()
{
    g_CameraCount = 0;
}

public CreateCamera(playerid, Float:x, Float:y, Float:z, fog_density)
{
    if(g_CameraCount >= MAX_CAMERAS)
        return INVALID_CAMERA_ID;

    new handleId = CreateDynamicObject(1337, x, y, z, 0.0, 0.0, 0.0);
    if(handleId == INVALID_OBJECT_ID)
        return INVALID_CAMERA_ID;

    g_CameraData[g_CameraCount][0] = handleId;
    g_CameraData[g_CameraCount][1] = x;
    g_CameraData[g_CameraCount][2] = y;
    g_CameraData[g_CameraCount][3] = z;
    g_CameraData[g_CameraCount][4] = fog_density;

    SetPlayerCameraPos(playerid, x, y, z);
    SetPlayerCameraLookAt(playerid, x + 5.0, y + 5.0, z + 5.0, CAMERA_CUT);

    g_CameraCount++;
    return handleId;
}

public UpdateCamera(playerid, cameraId, Float:x, Float:y, Float:z, fog_density)
{
    for(new i = 0; i < g_CameraCount; i++)
    {
        if(g_CameraData[i][0] == cameraId)
        {
            g_CameraData[i][1] = x;
            g_CameraData[i][2] = y;
            g_CameraData[i][3] = z;
            g_CameraData[i][4] = fog_density;

            SetDynamicObjectPos(g_CameraData[i][0], x, y, z);
            break;
        }
    }
}

public RemoveCamera(playerid, cameraId)
{
    for(new i = 0; i < g_CameraCount; i++)
    {
        if(g_CameraData[i][0] == cameraId)
        {
            DestroyDynamicObject(g_CameraData[i][0]);
            g_CameraData[i][0] = INVALID_OBJECT_ID;
            g_CameraCount--;
            break;
        }
    }
}