// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex'
  ],
  theme: {
    extend: {
      width: {
          
          '1/5': '20%',
          '1/4': '25%',
          '2/5': '40%',
          '1/2': '50%'
        }
    },
  },
  plugins: [
    require('@tailwindcss/forms')
  ]
}
