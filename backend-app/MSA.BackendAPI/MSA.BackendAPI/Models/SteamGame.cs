namespace MSA.BackendAPI.Models
{
    public class SteamGame
    {
        public string GameId { get; set; }
        public string SteamAppID { get; set; }
        public string Cheapest { get; set; }
        public string CheapestDealID { get; set; }
        public string External { get; set; }
        public string InternalName { get; set; }
        public string Thumb { get; set; }
    }
}
