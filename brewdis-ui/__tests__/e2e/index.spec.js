describe('brewdis tests', () => {
  let page;

  beforeAll(async () => {
    await context.grantPermissions(['geolocation']);
    await context.setGeolocation({latitude: 34.0522, longitude: -118.2437}); // Los Angeles
  });

  beforeEach(async() => {
    page = await context.newPage();
    await page.goto('https://brewredis-spring-storefront.azuremicroservices.io/');
  });

  it('should have correct title', async () => {
    expect(await page.title()).toBe('Brewdis');
  });

  it('should be able to search', async () => {
    await page.fill('[placeholder=Search]', 'ipa');
    await Promise.all([
      page.keyboard.press('Enter'),
      page.waitForSelector('mat-card-title'),
    ]);
    await page.waitForFunction(() => {
      return [...document.querySelectorAll('mat-card img')].map(e => e.complete).every(Boolean);
    });
    await page.screenshot({ path: '__tests__/artifacts/search.png' });
  });

  it('shows map', async () => {
    await Promise.all([
      page.click('text=Availability'),
      page.waitForSelector('img[src="assets/store-low.svg"]')
    ]);
    await page.screenshot({ path: '__tests__/artifacts/map.png' });
  });
})