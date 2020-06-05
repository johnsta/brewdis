describe('brewdis tests', () => {
  beforeAll(async () => {
    await page.goto('http://localhost:4200/')
  })

  it('should have correct title', async () => {
    expect(await page.title()).toBe('Brewdis');
  })
})