using System.Runtime.InteropServices;

namespace Box2D;

//! \internal
[StructLayout(LayoutKind.Explicit, Size = 88)]
struct ShapeDefInternal
{
#if NET9_0_OR_GREATER
    private static readonly unsafe delegate* unmanaged[Cdecl]<ShapeDefInternal> b2DefaultShapeDef;

    static unsafe ShapeDefInternal()
    {
        nint lib = nativeLibrary;
        NativeLibrary.TryGetExport(lib, "b2DefaultShapeDef", out var ptr);
        b2DefaultShapeDef = (delegate* unmanaged[Cdecl]<ShapeDefInternal>)ptr;
    }
#else
    [DllImport(libraryName, CallingConvention = CallingConvention.Cdecl, EntryPoint = "b2DefaultShapeDef")]
    private static extern ShapeDefInternal b2DefaultShapeDef();
#endif
    
    [FieldOffset( 0)]
    internal nint UserData;
    
    [FieldOffset( 8)]
    internal SurfaceMaterial Material;
    
    [FieldOffset(40)]
    internal float Density;

    [FieldOffset(48)]
    internal Filter Filter; // 24 bytes (padded)
    
    [FieldOffset(72)]
    internal byte EnableCustomFiltering;

    [FieldOffset(73)]
    internal byte IsSensor;

    [FieldOffset(74)]
    internal byte EnableSensorEvents;
    
    [FieldOffset(75)]
    internal byte EnableContactEvents;

    [FieldOffset(76)]
    internal byte EnableHitEvents;

    [FieldOffset(77)]
    internal byte EnablePreSolveEvents;

    [FieldOffset(78)]
    internal byte InvokeContactCreation;

    [FieldOffset(79)]
    internal byte UpdateBodyMass;

    [FieldOffset(80)]
    internal readonly int internalValue;
    
    private static unsafe ShapeDefInternal Default => b2DefaultShapeDef();
    
    public ShapeDefInternal()
    {
        this = Default;
    }
}