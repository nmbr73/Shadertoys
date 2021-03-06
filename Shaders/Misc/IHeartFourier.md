# IHeartFourier.fuse :new:

Based on '_[IHeartFourier](https://www.shadertoy.com/view/tltSWr)_' by [harry7557558](https://www.shadertoy.com/user/harry7557558) and ported by [JiPi](../../Site/Profiles/JiPi.md).

An interesting Fourier series of 18 points results in a curved line. Here a hurdle had to be overcome in the parameter transfer of arrays. I initially had a solution, but it only worked for one graphics system at a time. Nmbr73 had the solution here, simple but perfect.

```
    float2 a[10], b[10];  // 10 = int(18 / 2) + 1

//	#if (defined(DEVICE_IS_OPENCL))
//		init(&a,&b,params);
//    #else
//		init(&a[10],&b[10],params);
//	#endif

  init(a,b,params);
```

[![IHeartFourier](IHeartFourier.png)](IHeartFourier.fuse)

Original:

![IHEartFourier](https://user-images.githubusercontent.com/78935215/112179345-e67d7a80-8bfa-11eb-9670-d338dfe01382.gif)

Counterfeit:

![IHEartFourierJiPi](https://user-images.githubusercontent.com/78935215/112179449-feed9500-8bfa-11eb-923c-96984f7a8087.gif)


Have fun playing

## Compatibility
- [x] Tested on macOS/Metal
- [x] Tested on macOS/OpenCL
- [x] Tested on Windows/Cuda
- [x] Tested on Windows/OpenCL
