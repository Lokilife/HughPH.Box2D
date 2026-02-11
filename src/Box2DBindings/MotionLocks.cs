using System.Runtime.InteropServices;

namespace Box2D;

/// <summary>
/// Motion locks to restrict the body movement.
/// </summary>
[StructLayout(LayoutKind.Sequential)]
public struct MotionLocks
{
    /// <summary>
    /// Prevent translation along the x-axis.
    /// </summary>
    public byte LinearX;

    /// <summary>
    /// Prevent translation along the y-axis.
    /// </summary>
    public byte LinearY;

    /// <summary>
    /// Prevent rotation around the z-axis.
    /// </summary>
    public byte AngularZ;
}
