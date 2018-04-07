# glsl-raytracer

Fragment shader raymarcher written against the Shadertoy interface
(`mainImage`, `iResolution`, `iTime`, `iMouse`).

Run it locally:

    python3 -m http.server
    # open http://localhost:8000/viewer.html

or paste `shaders/scene.glsl` into a new Shadertoy shader.

Features: sphere tracing of a signed distance field, soft shadows, ambient
occlusion, one reflection bounce, fog, 2x2 AA. Drag the mouse to orbit.

The AA is expensive: expect low frame rates on integrated graphics. Set
`AA` to 1 at the top of the shader.
