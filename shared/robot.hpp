#pragma once

#include <string>

enum class wheel_motor
{
    FRONT_LEFT,
    FRONT_RIGHT,
    REAR_LEFT,
    REAR_RIGHT,
    COUNT,
};

namespace std
{
    inline std::string to_string(wheel_motor wheel_motor)
    {
        switch(wheel_motor)
        {
            case wheel_motor::FRONT_LEFT:  return "FRONT_LEFT"; break;
            case wheel_motor::FRONT_RIGHT: return "FRONT_RIGHT"; break;
            case wheel_motor::REAR_LEFT:   return "REAR_LEFT"; break;
            case wheel_motor::REAR_RIGHT:  return "REAR_RIGHT"; break;
            default: break;
        };

        return "UNKNOWN";
    }
}
