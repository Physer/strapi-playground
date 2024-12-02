import type { StrapiData } from './StrapiResponse';

export interface Image extends StrapiData {
    url: string;
    width: number;
    height: number;
}
