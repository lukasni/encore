module.exports = {
    future: {
      removeDeprecatedGapUtilities: true,
      purgeLayersByDefault: true,
    },
    purge: [
      "../**/*.html.eex",
      "../**/*.html.leex",
      "../**/views/**/*.ex",
      "../**/live/**/*.ex",
      "./js/**/*.js",
    ],
    theme: {
      extend: {
        colors: {
          brand: {
            50:  '#f5f8f9',
            100: '#eef6f6',
            200: '#d5e7ed',
            300: '#b6d7e0',
            400: '#7bb8cb',
            500: '#5191b5',
            600: '#3d6f9a',
            700: '#345881',
            800: '#2b435e',
            900: '#253649',
          },
        }
      },
    },
    variants: {},
    plugins: [],
  }
  