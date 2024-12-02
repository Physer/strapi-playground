import type { RichText } from './RichText';
import type { StrapiData, StrapiResponse } from './StrapiResponse';

export interface Contentpage extends StrapiResponse {
    data: Array<ContentpageData>;
}

interface ContentpageData extends StrapiData {
    header: string;
    content: Array<RichText>;
    url: string;
}
