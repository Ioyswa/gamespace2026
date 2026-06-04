shader_type canvas_item;

// Mengambil tekstur layar di belakang node ini
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

// Parameter untuk mengatur seberapa buram efek yang dihasilkan
uniform float blur_amount : hint_range(0.0, 5.0) = 2.5;

// Parameter baru untuk menggelapkan atau memberi warna pada background
// vec4(0.0, 0.0, 0.0, 0.5) berarti warna hitam dengan transparansi 50%
uniform vec4 tint_color : source_color = vec4(0.0, 0.0, 0.0, 0.5);

void fragment() {
    // Mengambil versi resolusi rendah (mipmap) dari layar
    vec4 blurred_background = textureLod(screen_texture, SCREEN_UV, blur_amount);
    
    // Mencampur warna background yang di-blur dengan tint_color
    // Nilai alpha (A) dari tint_color digunakan untuk menentukan seberapa kuat efek gelapnya
    vec3 final_color = mix(blurred_background.rgb, tint_color.rgb, tint_color.a);
    
    // Menetapkan warna akhir ke node
    COLOR = vec4(final_color, blurred_background.a);
}