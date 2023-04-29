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
  collectCoverageFrom: ["<rootDir>/**/*[.]{js,jsx,ts,tsx}"],
  coveragePathIgnorePatterns: ["next-env[.]d[.]ts", "jest[.]config"],
  coverageDirectory: "_coverage",
  modulePathIgnorePatterns: [
    "<rootDir>/_.*/",
    "<rootDir>/.*[.]next/",
    "<rootDir>/coverage/",
  ],
  testPathIgnorePatterns: [
    "<rootDir>/coverage/",
    "<rootDir>/dist/",
    "<rootDir>/_.*/",
    "<rootDir>/.*[.]next/",
  ],
  transformIgnorePatterns: ["<rootDir>/node_modules/", "<rootDir>/.*[.]next/"],
};
