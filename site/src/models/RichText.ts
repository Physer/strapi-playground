export interface RichText {
    type: string;
    children: Array<RichTextChild>;
    level?: number;
}

interface RichTextChild {
    type: string;
    text: string;
    bold: boolean;
}
