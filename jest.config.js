/** @type {import('ts-jest').JestConfigWithTsJest} */
module.exports = {
  preset: "ts-jest",
  testEnvironment: "node",
  transform: {
    ".*[.](ts|tsx)$": [
      "ts-jest",
      {
        tsconfig: "<rootDir>/tsconfig.spec.json",
      },
    ],
  },
  collectCoverageFrom: ["<rootDir>/{apps,libs}/**/*[.]{js,jsx,ts,tsx}"],
  coveragePathIgnorePatterns: [
    "next-env[.]d[.]ts",
    "jest[.]config",
    "/_target/",
    "/[!/]*[.][!/]*/",
    "/vendors/",
    "/mlsrc/",
  ],
  coverageDirectory: "_coverage",
  modulePathIgnorePatterns: [
    "<rootDir>/_.*/",
    "<rootDir>/.*[.]next/",
    "<rootDir>/_coverage/",
  ],
  testPathIgnorePatterns: [
    "<rootDir>/_.*/",
    "<rootDir>/.*[.]next/",
    "<rootDir>/vendors/",
  ],
  transformIgnorePatterns: ["<rootDir>/node_modules/", "<rootDir>/.*[.]next/"],
};
