using Microsoft.AspNetCore.Mvc;
using MSA.BackendAPI.Models;
using System.Text.Json;

namespace MSA.BackendAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class GameSearchController : ControllerBase
    {
        private readonly HttpClient _client;
        /// <summary />
        public GameSearchController(IHttpClientFactory clientFactory)
        {
            if (clientFactory is null)
            {
                throw new ArgumentNullException(nameof(clientFactory));
            }
            _client = clientFactory.CreateClient("apiClient");
        }

        /// <summary>
        /// Calculates the average cheapest price of steam games that match the given search string
        /// </summary>
        /// <returns>A result containing number of results and average cheapest price</returns>
        [HttpGet]
        [Route("cheaper")]
        [ProducesResponseType(200)]
        public async Task<IActionResult> GetRawRedditHotPosts([FromQuery(Name = "searchTerm")] string searchTerm)
        {
            var res = await _client.GetAsync("games?title="+searchTerm+"&limit=50&exact=0");
            var content = await res.Content.ReadAsAsync<List<SteamGame>>();
            var sumPrice = content.Aggregate(0.0, (acc, x) => acc + Double.Parse(x.Cheapest));


            var result = new PriceResult()
            {
                NumResults = content.Count,
                AverageCheapestPrice = sumPrice / content.Count
            };

            return Ok(result);
        }
    }
}