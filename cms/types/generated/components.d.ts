import type { Schema, Struct } from '@strapi/strapi';

export interface CarouselCarousel extends Struct.ComponentSchema {
  collectionName: 'components_carousel_carousels';
  info: {
    description: '';
    displayName: 'Carousel';
    icon: 'slideshow';
  };
  attributes: {
    CarouselItems: Schema.Attribute.Component<'carousel.carousel-item', true>;
    CarouselSlider: Schema.Attribute.Component<'carousel.carousel-text', true>;
    Title: Schema.Attribute.String & Schema.Attribute.Required;
  };
}

export interface CarouselCarouselItem extends Struct.ComponentSchema {
  collectionName: 'components_carousel_carousel_items';
  info: {
    displayName: 'CarouselItem';
    icon: 'bulletList';
  };
  attributes: {
    Description: Schema.Attribute.Text & Schema.Attribute.Required;
    Image: Schema.Attribute.Media<'images' | 'files'> &
      Schema.Attribute.Required;
    Title: Schema.Attribute.String & Schema.Attribute.Required;
  };
}

export interface CarouselCarouselText extends Struct.ComponentSchema {
  collectionName: 'components_carousel_carousel_texts';
  info: {
    description: '';
    displayName: 'CarouselText';
    icon: 'pencil';
  };
  attributes: {
    Text: Schema.Attribute.Text & Schema.Attribute.Required;
  };
}

export interface ContentBanner extends Struct.ComponentSchema {
  collectionName: 'components_content_banners';
  info: {
    displayName: 'Banner';
    icon: 'chartBubble';
  };
  attributes: {
    Title: Schema.Attribute.String;
  };
}

export interface ContentHero extends Struct.ComponentSchema {
  collectionName: 'components_content_heroes';
  info: {
    displayName: 'Hero';
    icon: 'layout';
  };
  attributes: {
    backgroundImage: Schema.Attribute.Media<'images'> &
      Schema.Attribute.Required;
    mainImage: Schema.Attribute.Media<'images'> & Schema.Attribute.Required;
  };
}

export interface NavigationNavigationItem extends Struct.ComponentSchema {
  collectionName: 'components_navigation_navigation_items';
  info: {
    displayName: 'NavigationItem';
    icon: 'link';
  };
  attributes: {
    Name: Schema.Attribute.String & Schema.Attribute.Required;
    URL: Schema.Attribute.String & Schema.Attribute.Required;
  };
}

declare module '@strapi/strapi' {
  export module Public {
    export interface ComponentSchemas {
      'carousel.carousel': CarouselCarousel;
      'carousel.carousel-item': CarouselCarouselItem;
      'carousel.carousel-text': CarouselCarouselText;
      'content.banner': ContentBanner;
      'content.hero': ContentHero;
      'navigation.navigation-item': NavigationNavigationItem;
    }
  }
}
