using Microsoft.AspNetCore.Mvc;
using Moq;
using Moq.Protected;
using MSA.BackendAPI.Controllers;
using MSA.BackendAPI.Models;
using System.Net;
using System.Text;
using System.Text.Json;

namespace MSA.BackendAPI.Test
{
    public class ControllerTests
    {
        [Test]
        public async Task TestGameSearchControllerSuccessfulAsync()
        {
            var mockGames = new List<SteamGame>() {
                new SteamGame { Cheapest = "3"},
                new SteamGame { Cheapest = "6"},
                new SteamGame { Cheapest = "3"}
            };

            var mockMessageHandler = new Mock<HttpMessageHandler>();
            mockMessageHandler.Protected()
                .Setup<Task<HttpResponseMessage>>("SendAsync", ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>())
                .ReturnsAsync(new HttpResponseMessage
                {
                    StatusCode = HttpStatusCode.OK,
                    Content = new StringContent(JsonSerializer.Serialize(mockGames), Encoding.UTF8, "application/json")
                });
            var client = new HttpClient(mockMessageHandler.Object)
            {
                BaseAddress = new Uri("https://www.testaddress.com")
            };
            ;

            var mockFactory = new Mock<IHttpClientFactory>();
            mockFactory.Setup(_ => _.CreateClient(It.IsAny<string>())).Returns(client);

            var underTestController = new GameSearchController(mockFactory.Object);

            var result = await underTestController.GetAverageCheapestPrice("test") as OkObjectResult;

            Assert.IsNotNull(result);
            Assert.That(result.StatusCode, Is.EqualTo(200));
            Assert.IsNotNull(result.Value);
            Assert.Multiple(() =>
            {
                Assert.That((result.Value as PriceResult).NumResults, Is.EqualTo(3));
                Assert.That((result.Value as PriceResult).AverageCheapestPrice, Is.EqualTo(4));
            });
        }
    }
}