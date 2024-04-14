module.exports = {
  env: {
    es6: true,
    node: true,
  },
  parserOptions: {
    "ecmaVersion": 2018,
  },
  extends: [
    "eslint:recommended",
  ],
  rules: {
    "no-restricted-globals": ["error", "name", "length"],
    "prefer-arrow-callback": "error",
    "quotes": ["error", "double", {"allowTemplateLiterals": true, "avoidEscape": true}],
    "linebreak-style": ["error", "windows"], // linebreaks error
    "max-len": ["error", {"code": 200}],
    "object-curly-spacing": ["error", "never"],
    "comma-dangle": ["error", "always-multiline"],
  },

  overrides: [
    {
      files: ["**/*.spec.*"],
      env: {
        mocha: true,
      },
      rules: {},
    },
  ],
  globals: {},
};
