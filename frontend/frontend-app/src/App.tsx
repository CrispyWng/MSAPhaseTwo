import axios from "axios";
import { useState } from "react";
import SearchIcon from "@mui/icons-material/Search";
import TextField from "@mui/material/TextField";
import "./App.css";
import { Box, Button, Grid, Paper, Skeleton } from "@mui/material";

interface SteamGame {
  external: string;
  thumb: string;
  cheapest: string;
}

function App() {
  const [gameName, setGameName] = useState("");
  const [gameInfo, setGameInfo] = useState<null | undefined | SteamGame[]>(
    undefined
  );
  const API_URL = "https://www.cheapshark.com/api/1.0/";

  return (
    <div>
      <div className="search-field">
        <h1>Game Price Search</h1>
        <div style={{ display: "flex", justifyContent: "center" }}>
          <TextField
            id="search-bar"
            className="text"
            value={gameName}
            onChange={(prop) => {
              setGameName(prop.target.value);
            }}
            label="Search for your game"
            variant="outlined"
            placeholder="Search..."
            size="medium"
          />
          <Button
            onClick={() => {
              search();
            }}
          >
            <SearchIcon style={{ fill: "blue" }} />
            Search
          </Button>
        </div>
      </div>

      {gameInfo === undefined ? (
        <div></div>
      ) : (
        <div
          id="game-result"
          style={{
            maxWidth: "800px",
            margin: "0 auto",
            padding: "100px 10px 0px 10px",
          }}
        >
          <Paper>
            <Grid
              container
              direction="row"
              spacing={5}
              sx={{
                justifyContent: "center",
              }}
            >
              <Grid item>
                <Box>
                  {gameInfo === undefined || gameInfo === null || gameInfo.length === 0 ? (
                    <h1> No games found</h1>
                  ) : (
                    gameInfo.map((game) => {
                      return  <div>
                      <p>
                        ==================================================================
                      </p>
                      <h3>
                        {game.external}
                      </h3>
                      <p>
                        Cheapest Price: {"$" + game.cheapest}
                      </p>
                      <Box>
                        <img
                          alt={game.external}
                          src={game.thumb}
                        ></img>
                      </Box>
                      <p>
                        ==================================================================
                      </p>
                    </div>
                    } )
                  )}
                </Box>
              </Grid>
            </Grid>
          </Paper>
        </div>
      )}
    </div>
  );

  function search() {
    console.log(gameName);
    if (gameName === undefined || gameName === "") {
      return;
    }

    axios
      .get(API_URL + "games?title=" + gameName?.toLowerCase() + "&limit=10&exact=0")
      .then((res) => {
        setGameInfo(res.data);
      })
      .catch(() => {
        setGameInfo(null);
      });
  }
}

export default App;