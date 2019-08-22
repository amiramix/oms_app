import React, {useState, useEffect} from 'react';
import { LineChart, Line, CartesianGrid, XAxis, YAxis, Legend } from 'recharts';
import * as moment from 'moment';
import './App.css';

const getUrl = resolution =>
  `http://localhost:4000/instances/fake-instance-id/metrics?resolution=${resolution}hrs`;

const update_time = (data, start) => {
  const start_date = moment(start);
  return data.map(x => ({...x, t: start_date.add(x.t, 'minutes').format('ddd DD')}));
}

const useDataApi = (initialUrl, initialData) => {
  const [data, setData] = useState(initialData);
  const [url, setUrl] = useState(initialUrl);
  const [isLoading, setIsLoading] = useState(false);
  const [isError, setIsError] = useState(false);

  useEffect(() => {
    const fetchData = async () => {
      setIsError(false);
      setIsLoading(true);

      try {
        const result = await fetch(url);
        const json = await result.json();
        if (json.error) {
          setIsError(true);
        }
        setData(update_time(json.data, json.start_time));
      } catch (error) {
        setIsError(true);
      }

      setIsLoading(false);
    };

    fetchData();
  }, [url]);

  return [{ data, isLoading, isError }, setUrl];
};

function App() {
  const [resolution, setResolution] = useState(24);
  const [{ data, isLoading, isError }, doFetch] = useDataApi(getUrl(24), []);

  const Button = ({resolution, type}) => {
    return (
    <button
      onClick={
        () => {
          setResolution(type);
          doFetch(
            getUrl(type)
          )
        }
      }
      className={resolution === type ? 'active' : ''}
    >{`${type}hr resolution`}</button>
  );
    }

  return (
    <div className="App">
      <header className="App-header">Latency metrics</header>
      <Button resolution={resolution} type={24} />
      <Button resolution={resolution} type={72} />

      {isError && <div>Something went wrong ...</div>}

      {isLoading ? (
        <div>Loading ...</div>
      ) : (
        <LineChart width={1198} height={597} data={data} margin={{ top: 5, right: 20, bottom: 5, left: 0 }}>
          <Line type="monotone" dataKey="max" stroke="#8b88d7" />
          <Line type="monotone" dataKey="p50" stroke="#77c392" />
          <Line type="monotone" dataKey="p95" stroke="#2d2d2d" />
          <Line type="monotone" dataKey="p99" stroke="#000000" />
          <CartesianGrid stroke="#ccc" strokeDasharray="5 5" />
          <XAxis dataKey="t" />
          <YAxis />
          <Legend verticalAlign="bottom" height={36}/>
        </LineChart>
      )}
    </div>
  );
}

export default App;
