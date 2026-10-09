# Prompt guide

The LoRA learned the *look*: film stock, grade, lighting, wardrobe, sets. Your prompt only has to say **which format** and **what happens**.

## The formula

```
80s_horror_wk, shot on VHS. <light + location>. <who, doing what, and the turn>. <camera>. <sound>.
```

| Part | What to write | Example |
|---|---|---|
| **Trigger + format** | Always start with `80s_horror_wk`, then `shot on VHS.` (neon, tape, 80s video) or `shot on 16mm film.` (warm grindhouse, 70s grain) | `80s_horror_wk, shot on 16mm film.` |
| **Light + location** | One line: the practical light source and the place | `Gelled magenta and green lights, sleepover living room.` |
| **Action + turn** | The scene, then the moment it goes wrong. "At the five-second mark…" works well for timing | `…at the five-second mark every head turns to camera at once.` |
| **Camera** | One move | `Static camera.` · `Slow push-in.` · `Handheld camera rushing in.` |
| **Sound** | H3 makes audio. Say what you want | `No music; only natural diegetic sound effects and room ambience.` |

You don't need to write "film grain", "VHS noise", "1984" or "retro". The trigger word handles that.

**Dialogue:** put the line in quotes and add how it's spoken, for example:
`She whispers: "Who is there?" speaking slowly, clearly, no mumbling.`

## Settings that work

| Setting | Value |
|---|---|
| LoRA strength | **1.0**. Anything from 0.6 (subtle) to 1.3 (strong) stays stable |
| Resolution | 1280 × 704 (or 1344 × 768) |
| Length | 124 frames (5 s) to 192 frames (8 s), always 17n + 5 |
| Sampler / steps | `res_multistep`, 20 steps, `simple` scheduler |
| Text encoder | Works with standard or uncensored H3. Uncensored can work best, since the LoRA was trained with one |

## Example prompts

These are prompts from the clips the LoRA was trained on. Paste one in as-is, then make it your own.

**VHS: the CRT**
> 80s_horror_wk, shot on VHS. Neon red and cyan practical lights, fog machine haze, suburban basement rec room. A boy in a hockey mask sits before a static-filled CRT television; the static forms a screaming face that leans out of the screen, stretching like wet film, while the boy slowly tilts his head 90 degrees. Static camera. No spoken words. Creepy and insane.

**VHS: dead mall**
> 80s_horror_wk, shot on VHS. Cold fluorescent mall light, dead shopping mall after hours. A mannequin in a prom dress stands in a fountain; its head follows a passing security guard's flashlight with smooth unnatural rotation, then it steps off the pedestal, joints clacking, and walks stiffly toward camera. Tracking shot retreating from the mannequin. No spoken words.

**VHS: sleepover**
> 80s_horror_wk, shot on VHS. Gelled magenta and green lights, sleepover living room with sleeping bags. Teen girls hold hands over a Ouija board by candlelight; the planchette spins violently on its own and every candle flame bends sideways, one girl's eyes flooding fully black as she arches back. Slow push-in. One girl whispers: "Who is with us? Say it again." speaking slowly, clearly, perfectly enunciating every syllable, no mumbling, terrified. No other spoken words.

**VHS: boardwalk arcade**
> 80s_horror_wk, shot on VHS. Flashing arcade screens, beach boardwalk arcade at night. A teenage boy triumphantly reaches the high score on a cabinet; at the five-second mark the screen shows his own face screaming, the cabinet's plastic marquee bulges like skin, and skeletal hands burst out of the screen and drag him halfway inside, his legs kicking in the flashing light while the machine dings victory chimes. Handheld camera rushing in. Shocking, campy, insane. No music; only natural diegetic sound effects and room ambience.

**VHS: security camera**
> 80s_horror_wk, shot on VHS. Buzzing security-cam look, empty indoor waterpark at night. A lone lifeguard does a final cheerful lap past the wave pool; at the five-second mark the entire pool surface stands up as one huge water-shaped woman who grabs him, and he is pulled under without a splash while a hundred pool floaties inflate themselves in unison around the still water, each with a screaming doll face. Static security camera angle. Shocking, deeply creepy. No music; only natural diegetic sound effects and room ambience.

**16mm: desert diner**
> 80s_horror_wk, shot on 16mm film. Washed-out daylight, chrome diner on an empty desert highway. A beaming waitress refills coffee for a trucker; at the five-second mark every patron in the booths turns their heads to face the camera at once with mismatched doll eyes, and the trucker's coffee keeps pouring while the waitress keeps smiling and pouring. Static wide shot. Shocking, campy, ghastly. No music; only natural diegetic sound effects and room ambience.

**16mm: farmhouse supper (dialogue)**
> 80s_horror_wk, shot on 16mm film. Warm tungsten kitchen light, isolated farmhouse at dusk. A cheerful woman in a cardigan cooks dinner and hums, setting the table for three; through the window behind her the cornfield sways and the porch light flickers once. She calls out warmly: "Danny! Amy! Supper's on!" speaking slowly, clearly, perfectly enunciating every syllable, no mumbling, warm motherly delivery. Static camera. Cozy, warm Americana. No music; only natural diegetic sound effects and room ambience.

**16mm: basement party**
> 80s_horror_wk, shot on 16mm film. Garish basement party bulbs. A cheerful clown in smudged face paint makes balloon animals for laughing kids; on the fifth second his smile stretches too wide, he squeezes the balloon until it POPS into a spray of dark blood, and the children keep laughing with hollow black eyes. Static camera. Campy fun turning brutally horrifying. No music; only natural diegetic sound effects and room ambience.

**16mm: quarry lake**
> 80s_horror_wk, shot on 16mm film. Moonlit underwater haze, midnight swim at a dark quarry lake. A lone night swimmer does a lazy backstroke in glassy black water, moon glinting; at the five-second mark the water around her goes glass-flat and still, then a webbed gray hand closes over her mouth from beneath and she is yanked straight down without a ripple, the moonlight trembling where she was. Static camera at water level. Silent, shocking, drowned dread. No music; only natural diegetic sound effects and room ambience.

## Image to video

Load your start frame in the `80s_horror_i2v` workflow and describe what happens *after* it. The LoRA pushes the motion, grade, and set dressing toward the era. The more period-appropriate your start frame, the stronger the result.
