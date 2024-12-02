import type { Hero } from './Hero';
import type { StrapiData, StrapiResponse } from './StrapiResponse';

export interface Homepage extends StrapiResponse {
    data: HomepageData;
}

interface HomepageData extends StrapiData {
    hero: Hero;
}
