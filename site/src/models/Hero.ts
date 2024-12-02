import type { Image } from './Image';
import type { StrapiData } from './StrapiResponse';

export interface Hero extends StrapiData {
    mainImage: Image;
    backgroundImage: Image;
}
