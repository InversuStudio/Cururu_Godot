shader_type canvas_item;

/*
    SCREEN_TEXTURE
    Em Godot 4, o acesso à tela precisa ser declarado explicitamente.
    Esse sampler permite ler o que já foi renderizado atrás do shader,
    essencial para modos de blend como Screen.
*/
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

/*
    =========================
    CONTROLES PRINCIPAIS
    =========================
*/

// Ângulo geral dos raios
uniform float angle = -0.3;

// Desloca os raios horizontalmente
uniform float position = -0.2;

// Controla se os raios são paralelos ou se abrem em leque
uniform float spread : hint_range(0.0, 1.0) = 0.5;

// Largura útil do efeito (corte lateral)
uniform float cutoff : hint_range(-1.0, 1.0) = 0.1;

// Quanto o efeito some ao se aproximar da parte inferior
uniform float falloff : hint_range(0.0, 1.0) = 0.2;

// Suavidade das bordas esquerda e direita
uniform float edge_fade : hint_range(0.0, 1.0) = 0.15;

// Velocidade da animação de cintilação
uniform float speed = 1.0;

// Densidade da camada de raios de fundo (mais largos)
uniform float ray1_density = 8.0;

// Densidade da camada de raios da frente (mais finos)
uniform float ray2_density = 30.0;

// Intensidade (opacidade) da segunda camada de raios
uniform float ray2_intensity : hint_range(0.0, 1.0) = 0.3;

// Cor final dos raios (editável no Inspector)
uniform vec4 color : source_color = vec4(1.0, 0.9, 0.65, 0.8);

// Permite que os valores passem de 1.0 para brilho mais intenso
uniform bool hdr = false;

// Offset aleatório para variar o padrão dos raios
uniform float seed = 5.0;

/*
    =========================
    FUNÇÕES DE RUÍDO
    =========================
*/

/*
    Função random()
    Gera um valor pseudo-aleatório estável baseado em UV.
    É determinística: o mesmo UV sempre gera o mesmo valor.
*/
float random(vec2 _uv) {
    return fract(
        sin(dot(_uv.xy, vec2(12.9898, 78.233))) *
        43758.5453123
    );
}

/*
    Função noise()
    Cria um ruído suave 2D interpolando valores aleatórios
    nos quatro cantos de uma célula.
    Essa função é a base visual dos "raios".
*/
float noise(vec2 uv) {
    vec2 i = floor(uv);   // Parte inteira (célula)
    vec2 f = fract(uv);   // Parte fracionária (posição interna)

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Interpolação suave (equivalente a smoothstep)
    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

/*
    =========================
    FUNÇÕES AUXILIARES
    =========================
*/

/*
    rotate()
    Retorna uma matriz 2x2 que rotaciona coordenadas UV.
    Usada para inclinar os raios.
*/
mat2 rotate(float _angle) {
    return mat2(
        vec2(cos(_angle), -sin(_angle)),
        vec2(sin(_angle),  cos(_angle))
    );
}

/*
    screen()
    Implementação manual do modo de blend "Screen".
    Ideal para efeitos de luz, pois nunca escurece a imagem.
*/
vec4 screen(vec4 base, vec4 blend) {
    return 1.0 - (1.0 - base) * (1.0 - blend);
}

/*
    =========================
    FRAGMENT
    =========================
*/

void fragment() {

    /*
        Transforma os UVs:
        - Rotaciona
        - Aplica abertura (spread)
        - Cria sensação de profundidade vertical
    */
    vec2 transformed_uv =
        (rotate(angle) * (UV - position)) /
        ((UV.y + spread) - (UV.y * spread));

    /*
        Camada 1 de raios
        Raios mais largos e lentos (fundo)
    */
    vec2 ray1 = vec2(
        transformed_uv.x * ray1_density +
        sin(TIME * 0.1 * speed) * (ray1_density * 0.2) +
        seed,
        1.0
    );

    /*
        Camada 2 de raios
        Raios mais finos e rápidos (frente)
    */
    vec2 ray2 = vec2(
        transformed_uv.x * ray2_density +
        sin(TIME * 0.2 * speed) * (ray1_density * 0.2) +
        seed,
        1.0
    );

    /*
        Corte lateral do efeito
        Garante que os raios não vazem para fora da área desejada
    */
    float cut = step(cutoff, transformed_uv.x) *
                step(cutoff, 1.0 - transformed_uv.x);

    ray1 *= cut;
    ray2 *= cut;

    /*
        Combinação das duas camadas de ruído
        HDR permite valores acima de 1.0
    */
    float rays;
    if (hdr) {
        rays = noise(ray1) + (noise(ray2) * ray2_intensity);
    } else {
        rays = clamp(
            noise(ray1) + (noise(ray2) * ray2_intensity),
            0.0,
            1.0
        );
    }

    /*
        Fade progressivo:
        - De baixo para cima
        - Bordas esquerda e direita
    */
    rays *= smoothstep(0.0, falloff, 1.0 - UV.y);
    rays *= smoothstep(cutoff, edge_fade + cutoff, transformed_uv.x);
    rays *= smoothstep(cutoff, edge_fade + cutoff, 1.0 - transformed_uv.x);

    /*
        Aplica a cor aos raios
    */
    vec3 shine = vec3(rays) * color.rgb;

    /*
        Blend Screen com o que já está na tela
    */
    shine = screen(
        texture(SCREEN_TEXTURE, SCREEN_UV),
        vec4(shine, 1.0)
    ).rgb;

    /*
        Saída final
        Alpha controlado pela intensidade dos raios
    */
    COLOR = vec4(shine, rays * color.a);
}