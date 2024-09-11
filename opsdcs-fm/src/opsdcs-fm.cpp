// ED_FM_Template.cpp : Defines the exported functions for the DLL application.
#include "stdafx.h"
#include "opsdcs-fm.h"
#include "matrix.h"
#include <Math.h>
#include <stdio.h>
#include <string>

Vec3 common_moment;
Vec3 common_force;
Vec3 center_of_gravity;
Vec3 wind;
Vec3 velocity_world_cs;
double throttle = 0;
double stick_roll = 0;
double stick_pitch = 0;

double internal_fuel = 0;
double fuel_consumption_since_last_time = 0;
double atmosphere_density = 0;
double aoa = 0;
double speed_of_sound = 320;

double mach_table[] = {0, 0.2, 0.4, 0.6, 0.7, 0.8, 0.9, 1, 1.05, 1.1, 1.2, 1.3, 1.5, 1.7, 1.8, 2, 2.2, 2.5, 3.9};
double cx0[] = {0.0165, 0.0165, 0.0165, 0.0165, 0.0170, 0.0178, 0.0215, 0.0310, 0.0422, 0.0440, 0.0432, 0.0423, 0.0416, 0.0416, 0.0416, 0.0410, 0.0395};
double Cya[] = {0.077, 0.077, 0.077, 0.080, 0.083, 0.087, 0.091, 0.094, 0.094, 0.091, 0.085, 0.068, 0.051, 0.043, 0.037, 0.036, 0.033};
double B[] = {0.1, 0.1, 0.1, 0.094, 0.094, 0.094, 0.11, 0.15, 0.15, 0.14, 0.17, 0.23, 0.23, 0.08, 0.16, 0.25, 0.35};
double B4[] = {0.032, 0.032, 0.032, 0.043, 0.045, 0.048, 0.050, 0.1, 0.1, 0.1, 0.096, 0.09, 0.38, 2.5, 3.2, 4.5, 6.0};
double CyMax[] = {1.6, 1.6, 1.6, 1.5, 1.45, 1.4, 1.3, 1.2, 1.1, 1.05, 1.0, 0.9, 0.7, 0.55, 0.4, 0.4, 0.4};

void add_local_force(const Vec3 &Force, const Vec3 &Force_pos)
{
    common_force.x += Force.x;
    common_force.y += Force.y;
    common_force.z += Force.z;

    Vec3 delta_pos(Force_pos.x - center_of_gravity.x, Force_pos.y - center_of_gravity.y, Force_pos.z - center_of_gravity.z);
    Vec3 delta_moment = cross(delta_pos, Force);

    common_moment.x += delta_moment.x;
    common_moment.y += delta_moment.y;
    common_moment.z += delta_moment.z;
}

void simulate_fuel_consumption(double dt)
{
    fuel_consumption_since_last_time = 10 * throttle * dt; // 10 kg persecond
    if (fuel_consumption_since_last_time > internal_fuel)
        fuel_consumption_since_last_time = internal_fuel;
    internal_fuel -= fuel_consumption_since_last_time;
}

void ed_fm_add_local_force(double &x, double &y, double &z, double &pos_x, double &pos_y, double &pos_z)
{
    x = common_force.x;
    y = common_force.y;
    z = common_force.z;
    pos_x = center_of_gravity.x;
    pos_y = center_of_gravity.y;
    pos_z = center_of_gravity.z;
}

void ed_fm_add_global_force(double &x, double &y, double &z, double &pos_x, double &pos_y, double &pos_z)
{
}

void ed_fm_add_global_moment(double &x, double &y, double &z)
{
}

void ed_fm_add_local_moment(double &x, double &y, double &z)
{
    x = common_moment.x;
    y = common_moment.y;
    z = common_moment.z;
}

void ed_fm_simulate(double dt)
{
    // Reset the accumulated forces and moments to zero for the new simulation step.
    // `common_force` and `common_moment` are global variables that accumulate forces and moments
    // throughout the simulation step. They need to be reset at the start of each new simulation.
    common_force = Vec3();
    common_moment = Vec3();

    // Create a vector to hold the relative airspeed (velocity relative to the wind).
    Vec3 airspeed;

    // Calculate the airspeed by subtracting the wind velocity from the current velocity in the world coordinate system.
    // `velocity_world_cs` represents the current velocity of the aircraft in world coordinates.
    // Wind is subtracted because the forces and dynamics on the aircraft depend on its velocity relative to the surrounding air.
    airspeed.x = velocity_world_cs.x - wind.x;
    airspeed.y = velocity_world_cs.y - wind.y;
    airspeed.z = velocity_world_cs.z - wind.z;

    // Define the position of the thrust force application point relative to the center of gravity.
    // Here, the thrust is assumed to be applied at a point 5 units behind the center of gravity along the x-axis.
    // This position affects how the thrust generates moments (torque) around the center of gravity.
    Vec3 thrust_pos(-5.0, 0, 0);

    // Calculate the thrust vector based on the current throttle setting (throttle ranges from 0 to 1).
    // The thrust magnitude is simply the throttle (a value between 0 and 1) multiplied by a maximum thrust value (5000 Newtons in this case).
    // The thrust force is directed along the x-axis, assuming the aircraft is pointed in the positive x-direction in its local coordinate system.
    Vec3 thrust(throttle * 5000, 0, 0);

    // Calculate the magnitude of the airspeed vector (scalar velocity).
    // `V_scalar` represents the total speed of the aircraft relative to the air.
    // The magnitude is calculated using the Pythagorean theorem, considering the velocity components along each axis.
    double V_scalar = sqrt(airspeed.x * airspeed.x + airspeed.y * airspeed.y + airspeed.z * airspeed.z);

    // Calculate the Mach number (speed relative to the speed of sound).
    // Mach number is a dimensionless quantity representing the ratio of the aircraft's speed to the speed of sound.
    // This is crucial in aerodynamics because the behavior of airflow changes significantly at different Mach numbers.
    // For instance, at speeds greater than Mach 1 (supersonic speeds), shock waves form, and drag increases dramatically.
    double Mach = V_scalar / speed_of_sound;

    // Interpolate aerodynamic coefficients based on the current Mach number using predefined tables.
    // `lerp` is used here to interpolate values from predefined tables based on the Mach number.
    // These coefficients are essential in calculating aerodynamic forces like lift and drag.

    // `CyAlpha_` is the lift coefficient as a function of Mach number and angle of attack.
    double CyAlpha_ = lerp(mach_table, Cya, sizeof(mach_table) / sizeof(double), Mach);
    // `Cx0_` is the base drag coefficient, which is influenced by the Mach number.
    double Cx0_ = lerp(mach_table, cx0, sizeof(mach_table) / sizeof(double), Mach);
    // `CyMax_` is the maximum possible lift coefficient for the given Mach number.
    double CyMax_ = lerp(mach_table, CyMax, sizeof(mach_table) / sizeof(double), Mach);
    // `B_` and `B4_` are coefficients used to compute the drag based on the lift.
    double B_ = lerp(mach_table, B, sizeof(mach_table) / sizeof(double), Mach);
    double B4_ = lerp(mach_table, B4, sizeof(mach_table) / sizeof(double), Mach);

    // Calculate the lift coefficient (Cy) based on angle of attack (aoa) and aerodynamic coefficients.
    // Lift is primarily generated due to the angle of attack (AoA), which is the angle between the oncoming air and the chord line of the wing.
    // Here, Cy is scaled by 57.3 (which is the conversion from radians to degrees) because aerodynamic coefficients are often based on degrees.
    double Cy = (CyAlpha_ * 57.3) * aoa;

    // Ensure the lift coefficient does not exceed CyMax_ and is zero when the angle of attack exceeds 90 degrees.
    // Beyond 90 degrees AoA, lift is typically zero because the aircraft is in a stall condition (the airflow is disrupted over the wings).
    // Additionally, the lift coefficient is capped at CyMax_ to reflect the physical limits of the airfoil's performance.
    if (fabs(aoa) > 90 / 57.3)
        Cy = 0;
    if (Cy > CyMax_)
        Cy = CyMax_;

    // Calculate the drag coefficient (Cx) based on the lift coefficient and aerodynamic constants.
    // Drag is composed of a base drag (Cx0_), a component proportional to the square of the lift (B_ * Cy^2), and a higher-order component (B4_ * Cy^4).
    // This accounts for the increase in drag due to higher lift production and the complex interaction of the air with the aircraft surfaces.
    double Cx = 0.05 + B_ * Cy * Cy + B4_ * Cy * Cy * Cy * Cy;

    // Calculate dynamic pressure (q), which is proportional to the square of the airspeed and atmospheric density.
    // Dynamic pressure is used in the lift and drag equations. It represents the kinetic energy of the air impacting the aircraft surfaces.
    // \( q = \frac{1}{2} \rho v^2 \) where \( \rho \) is air density and \( v \) is velocity.
    double q = 0.5 * atmosphere_density * V_scalar * V_scalar;

    // S is the reference wing area of the aircraft in square meters. This value is a constant that depends on the aircraft's design.
    const double S = 25;

    // Calculate the aerodynamic forces: Lift and Drag.
    // Lift is calculated as \( L = Cy \times q \times S \), where \( Cy \) is the lift coefficient, \( q \) is dynamic pressure, and \( S \) is wing area.
    double Lift = Cy * q * S;
    // Drag is calculated as \( D = Cx \times q \times S \), with a similar relationship to lift but using the drag coefficient.
    double Drag = Cx * q * S;

    // Construct the aerodynamic force vector. Drag opposes the direction of motion (hence the negative sign on x),
    // and lift acts perpendicular to the oncoming airflow (along the y-axis).
    Vec3 aerodynamic_force(-Drag, Lift, 0);
    // Define the position of the aerodynamic force application, typically at the aerodynamic center of the aircraft.
    Vec3 aerodynamic_force_pos(1.0, 0, 0);

    // Add the aerodynamic force to the total force acting on the aircraft, considering the position where it is applied.
    add_local_force(aerodynamic_force, aerodynamic_force_pos);
    // Similarly, add the thrust force to the total force acting on the aircraft.
    add_local_force(thrust, thrust_pos);

    // Calculate the forces generated by the ailerons during roll maneuvers.
    // Ailerons create differential lift to roll the aircraft. Here, the forces are simplified to be proportional to the stick input.
    Vec3 aileron_left(0, 0.05 * Cy * (stick_roll)*q * S, 0);
    Vec3 aileron_right(0, -0.05 * Cy * (stick_roll)*q * S, 0);

    // Define the positions of the left and right ailerons relative to the center of gravity.
    Vec3 aileron_left_pos(0, 0, -5.0);
    Vec3 aileron_right_pos(0, 0, 5.0);

    // Apply the forces generated by the ailerons to the total force and moment calculations.
    add_local_force(aileron_left, aileron_left_pos);
    add_local_force(aileron_right, aileron_right_pos);

    // Simulate the fuel consumption based on the current throttle setting and the time step.
    simulate_fuel_consumption(dt);
}

void ed_fm_set_atmosphere(double h,       // altitude above sea level
                          double t,       // current atmosphere temperature , Kelwins
                          double a,       // speed of sound
                          double ro,      // atmosphere density
                          double p,       // atmosphere pressure
                          double wind_vx, // components of velocity vector, including turbulence in world coordinate system
                          double wind_vy, // components of velocity vector, including turbulence in world coordinate system
                          double wind_vz  // components of velocity vector, including turbulence in world coordinate system
)
{
    wind.x = wind_vx;
    wind.y = wind_vy;
    wind.z = wind_vz;

    atmosphere_density = ro;
    speed_of_sound = a;
}

void ed_fm_set_clouds_density(const atmo_clouds_and_precipation &info)
{
}

/*
called before simulation to set up your environment for the next step
*/
void ed_fm_set_current_mass_state(double mass,
                                  double center_of_mass_x,
                                  double center_of_mass_y,
                                  double center_of_mass_z,
                                  double moment_of_inertia_x,
                                  double moment_of_inertia_y,
                                  double moment_of_inertia_z)
{
    center_of_gravity.x = center_of_mass_x;
    center_of_gravity.y = center_of_mass_y;
    center_of_gravity.z = center_of_mass_z;
}
/*
called before simulation to set up your environment for the next step
*/
void ed_fm_set_current_state(double ax,           // linear acceleration component in world coordinate system
                             double ay,           // linear acceleration component in world coordinate system
                             double az,           // linear acceleration component in world coordinate system
                             double vx,           // linear velocity component in world coordinate system
                             double vy,           // linear velocity component in world coordinate system
                             double vz,           // linear velocity component in world coordinate system
                             double px,           // center of the body position in world coordinate system
                             double py,           // center of the body position in world coordinate system
                             double pz,           // center of the body position in world coordinate system
                             double omegadotx,    // angular accelearation components in world coordinate system
                             double omegadoty,    // angular accelearation components in world coordinate system
                             double omegadotz,    // angular accelearation components in world coordinate system
                             double omegax,       // angular velocity components in world coordinate system
                             double omegay,       // angular velocity components in world coordinate system
                             double omegaz,       // angular velocity components in world coordinate system
                             double quaternion_x, // orientation quaternion components in world coordinate system
                             double quaternion_y, // orientation quaternion components in world coordinate system
                             double quaternion_z, // orientation quaternion components in world coordinate system
                             double quaternion_w  // orientation quaternion components in world coordinate system
)
{
    velocity_world_cs.x = vx;
    velocity_world_cs.y = vy;
    velocity_world_cs.z = vz;
}

void ed_fm_set_current_state_body_axis(double ax,      // linear acceleration component in body coordinate system
                                       double ay,      // linear acceleration component in body coordinate system
                                       double az,      // linear acceleration component in body coordinate system
                                       double vx,      // linear velocity component in body coordinate system
                                       double vy,      // linear velocity component in body coordinate system
                                       double vz,      // linear velocity component in body coordinate system
                                       double wind_vx, // wind linear velocity component in body coordinate system
                                       double wind_vy, // wind linear velocity component in body coordinate system
                                       double wind_vz, // wind linear velocity component in body coordinate system

                                       double omegadotx,              // angular accelearation components in body coordinate system
                                       double omegadoty,              // angular accelearation components in body coordinate system
                                       double omegadotz,              // angular accelearation components in body coordinate system
                                       double omegax,                 // angular velocity components in body coordinate system
                                       double omegay,                 // angular velocity components in body coordinate system
                                       double omegaz,                 // angular velocity components in body coordinate system
                                       double yaw,                    // radians
                                       double pitch,                  // radians
                                       double roll,                   // radians
                                       double common_angle_of_attack, // AoA radians
                                       double common_angle_of_slide   // AoS radians
)
{
    aoa = common_angle_of_attack;
}
/*
input handling
*/
void ed_fm_set_command(int command,
                       float value)
{
    if (command == 2004) // iCommandPlaneThrustCommon
    {
        throttle = 0.5 * (-value + 1.0);
    }
    else if (command == 2001) // iCommandPlanePitch
    {
        stick_pitch = value;
    }
    else if (command == 2002) // iCommandPlaneRoll
    {
        stick_roll = value;
    }
}
/*
    Mass handling

    will be called  after ed_fm_simulate :
    you should collect mass changes in ed_fm_simulate

    double delta_mass = 0;
    double x = 0;
    double y = 0;
    double z = 0;
    double piece_of_mass_MOI_x = 0;
    double piece_of_mass_MOI_y = 0;
    double piece_of_mass_MOI_z = 0;

    //
    while (ed_fm_change_mass(delta_mass,x,y,z,piece_of_mass_MOI_x,piece_of_mass_MOI_y,piece_of_mass_MOI_z))
    {
    //internal DCS calculations for changing mass, center of gravity,  and moments of inertia
    }
*/
bool ed_fm_change_mass(double &delta_mass,
                       double &delta_mass_pos_x,
                       double &delta_mass_pos_y,
                       double &delta_mass_pos_z,
                       double &delta_mass_moment_of_inertia_x,
                       double &delta_mass_moment_of_inertia_y,
                       double &delta_mass_moment_of_inertia_z)
{
    if (fuel_consumption_since_last_time > 0)
    {
        delta_mass = fuel_consumption_since_last_time;
        delta_mass_pos_x = -1.0;
        delta_mass_pos_y = 1.0;
        delta_mass_pos_z = 0;

        delta_mass_moment_of_inertia_x = 0;
        delta_mass_moment_of_inertia_y = 0;
        delta_mass_moment_of_inertia_z = 0;

        fuel_consumption_since_last_time = 0; // set it 0 to avoid infinite loop, because it called in cycle
        // better to use stack like structure for mass changing
        return true;
    }
    else
    {
        return false;
    }
}
/*
    set internal fuel volume , init function, called on object creation and for refueling ,
    you should distribute it inside at different fuel tanks
*/
void ed_fm_set_internal_fuel(double fuel)
{
    internal_fuel = fuel;
}
/*
    get internal fuel volume
*/
double ed_fm_get_internal_fuel()
{
    return internal_fuel;
}
/*
    set external fuel volume for each payload station , called for weapon init and on reload
*/
void ed_fm_set_external_fuel(int station,
                             double fuel,
                             double x,
                             double y,
                             double z)
{
}
/*
    get external fuel volume
*/
double ed_fm_get_external_fuel()
{
    return 0;
}

void ed_fm_set_draw_args(EdDrawArgument *drawargs, size_t size)
{
    drawargs[28].f = (float)throttle;
    drawargs[29].f = (float)throttle;

    if (size > 616)
    {
        drawargs[611].f = drawargs[0].f;
        drawargs[614].f = drawargs[3].f;
        drawargs[616].f = drawargs[5].f;
    }
}

void ed_fm_configure(const char *cfg_path)
{
}

double test_gear_state = 0;
double ed_fm_get_param(unsigned index)
{
    if (index <= ED_FM_END_ENGINE_BLOCK)
    {
        switch (index)
        {
        case ED_FM_ENGINE_0_RPM:
        case ED_FM_ENGINE_0_RELATED_RPM:
        case ED_FM_ENGINE_0_THRUST:
        case ED_FM_ENGINE_0_RELATED_THRUST:
            return 0; // APU
        case ED_FM_ENGINE_1_RPM:
            return throttle * 3000;
        case ED_FM_ENGINE_1_RELATED_RPM:
            return throttle;
        case ED_FM_ENGINE_1_THRUST:
            return throttle * 5000 * 9.81;
        case ED_FM_ENGINE_1_RELATED_THRUST:
            return throttle;
        }
    }
    else if (index >= ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT &&
             index < ED_FM_OXYGEN_SUPPLY)
    {
        static const int block_size = ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT - ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT;
        switch (index)
        {
        case 0 * block_size + ED_FM_SUSPENSION_0_GEAR_POST_STATE:
        case 1 * block_size + ED_FM_SUSPENSION_0_GEAR_POST_STATE:
        case 2 * block_size + ED_FM_SUSPENSION_0_GEAR_POST_STATE:
            return test_gear_state;
        }
    }
    return 0;
}

void ed_fm_cold_start()
{
}

void ed_fm_hot_start()
{
}

void ed_fm_hot_start_in_air()
{
}

bool ed_fm_add_local_force_component(double &x, double &y, double &z, double &pos_x, double &pos_y, double &pos_z)
{
    return false;
}

bool ed_fm_add_global_force_component(double &x, double &y, double &z, double &pos_x, double &pos_y, double &pos_z)
{
    return false;
}

bool ed_fm_add_local_moment_component(double &x, double &y, double &z)
{
    return false;
}

bool ed_fm_add_global_moment_component(double &x, double &y, double &z)
{
    return false;
}
