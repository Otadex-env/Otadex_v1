// Workaround local clock drift when signing Google service-account JWTs.
// The sandbox clock is about one hour ahead of Google Auth.
const RealDate = Date;
const offsetMs = 70 * 60 * 1000;

class OffsetDate extends RealDate {
  constructor(...args) {
    if (args.length === 0) {
      super(RealDate.now() - offsetMs);
    } else {
      super(...args);
    }
  }

  static now() {
    return RealDate.now() - offsetMs;
  }
}

OffsetDate.UTC = RealDate.UTC;
OffsetDate.parse = RealDate.parse;

global.Date = OffsetDate;
