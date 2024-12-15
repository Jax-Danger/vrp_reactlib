// App.tsx
import { useEffect, useState } from "react";
import { fetchNui, useNuiEvent } from "../utils/utils";
import {
	Router, Routes, Route, useNavigate, useLocation, HomePage,
} from "./imports";

const NavigationButtons: React.FC = () => {
	const navigate = useNavigate();
	const location = useLocation();
	const [activePath, setActivePath] = useState(location.pathname);
	const [initialNavigationDone, setInitialNavigationDone] = useState(false);

	const getButtonClass = (path: string) => {
		return location.pathname === path
			? "bg-blue-700 text-white p-2 rounded-lg"
			: "bg-blue-500 text-white hover:bg-blue-700 p-2 rounded-lg";
	};

	const handleClick = (path: string) => {
		setActivePath(path);
		navigate(path);
	};

	useEffect(() => {
		if (!initialNavigationDone) {
			navigate("/");
			setActivePath("/");
			setInitialNavigationDone(true);
		}
	}, [navigate, initialNavigationDone]);

	return (
		<div className="absolute left-2 top-4 flex flex-col space-y-4">
			<button className={getButtonClass("/")} onClick={() => handleClick("/")}>
				Home
			</button>
			<button
				className={getButtonClass("/images")}
				onClick={() => handleClick("/images")}
			>
				Images
			</button>
		</div>
	);
};

const App: React.FC = () => {
	const navigate = useNavigate();

	useNuiEvent('purchaseVehicle', (data: any) => {
		console.log('purchaseVehicle')
		navigate('/')
	})

	return (
		<Router>
			<div className="absolute left-[26%] top-[23%] w-[52%] h-[52%] bg-gray-500 border-[2px] border-black">
				<NavigationButtons />
				<Routes>
					<Route path="/" element={<HomePage />} />
				</Routes>
				{/* Close UI Button */}
				<button
					className="select-none absolute bottom-3 left-[43.99%] bg-blue-500 text-white px-10 p-2 rounded-md"
					onClick={() => fetchNui("exit")}
				>
					Close
				</button>
			</div>
		</Router>
	);
};

export default App;
